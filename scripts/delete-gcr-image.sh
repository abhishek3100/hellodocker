#!/bin/bash


# envArrayLength=`echo ${envArray} | jq length`
# envArrayLength=$($envArray | jq length)
# echo $envArrayLength

imagesToKeep=2
repoArray[0]='gcr.io/abhishekplan/hellodocker'

for repoName in ${repoArray[*]}; do
(
    echo ${repoName}
    for imageName in $(gcloud container images list --repository=${repoName}); do
    (        
        imageArray=$(gcloud container images list-tags ${imageName} --format=json)
        imageArrayLength=`echo ${imageArray} | jq length`
        echo $imageArrayLength

        if [ "${imageArrayLength}" -gt "${imagesToKeep}" ]
        then
            imageNewLength=`expr $imageArrayLength - $imagesToKeep`
            echo $imageNewLength

            for digest in $(gcloud container images list-tags ${imageName} --sort-by=TIMESTAMP --format='get(digest)'   --limit=$imageNewLength); do
            (
                set -x
                gcloud container images delete -q --force-delete-tags "${imageName}@${digest}"
            )
            done 

        fi
    )
    done
)
done
