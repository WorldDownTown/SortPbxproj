#!/bin/sh

# Check arguments
if [ $# -ne 2 ]; then
    echo "A tag and token argument is needed!(ex: ./release.sh 1.2.3 xxxxxxx)"
    exit 1
fi

# build
make build

lib_name="sort-pbxproj"
tag=$1
token=$2
export GITHUB_TOKEN=$token
echo "Tag: '${tag}'"
echo "Token: '${token}'"
filename="${tag}.tar.gz"
echo "Filename: '${filename}'"

# Push tag
git tag $tag
git push origin $tag

curl -LOk "https://github.com/WorldDownTown/SortPbxproj/archive/${filename}"
sha256=$(shasum -a 256 $filename | cut -d ' ' -f 1)
echo "sha256:\n$sha256"
rm $filename

# Homebrew
formula_path="$lib_name.rb"
formula_url="https://api.github.com/repos/WorldDownTown/homebrew-taps/contents/$formula_path"
sha=`curl $formula_url | jq -r '.sha'`
echo "sha:\n$sha"
content_encoded=`cat formula.rb.tmpl | sed -e "s/{{TAG}}/$tag/" | sed -e "s/{{SHA256}}/$sha256/" | openssl enc -e -base64 | tr -d '\n '`
echo "content_encoded:\n$content_encoded"

commit_message="Update version to $tag"

curl -i -X PUT $formula_url \
   -H "Content-Type:application/json" \
   -H "Authorization:token $token" \
   -d \
"{
  \"content\":\"$content_encoded\",
  \"message\":\"$commit_message\",
  \"sha\":\"$sha\"
}"

brew upgrade $lib_name
zip -j $lib_name.zip /usr/local/bin/$lib_name

# GitHub Release
github-release release \
    --user WorldDownTown \
    --repo SortPbxproj \
    --tag $tag

github-release upload \
    --user WorldDownTown \
    --repo SortPbxproj \
    --tag $tag \
    --name "$lib_name.zip" \
    --file $lib_name.zip

rm $lib_name.zip
