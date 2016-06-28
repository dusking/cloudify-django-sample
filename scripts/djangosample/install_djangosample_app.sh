#!/bin/bash

set -e

function download() {

   url=$1
   name=$2

   if [ -f "`pwd`/${name}" ]; then
        ctx logger info "`pwd`/${name} already exists, No need to download"
   else
        # download to given directory
        ctx logger info "Downloading ${url} to `pwd`/${name}"

        set +e
        curl_cmd=$(which curl)
        wget_cmd=$(which wget)
        set -e

        if [[ ! -z ${curl_cmd} ]]; then
            curl -L -o ${name} ${url}
        elif [[ ! -z ${wget_cmd} ]]; then
            wget -O ${name} ${url}
        else
            ctx logger error "Failed to download ${url}: Neither 'cURL' nor 'wget' were found on the system"
            exit 1;
        fi
   fi

}

function extract() {

    archive=$1
    destination=$2

    if [ ! -d ${destination} ]; then

        if [[ ${archive} == *".zip"* ]]; then

            set +e
            unzip_cmd=$(which unzip)
            set -e

            if [[ -z ${unzip_cmd} ]]; then
                ctx logger error "Cannot extract ${archive}: 'unzip' command not found"
                exit 1
            fi
            inner_name=$(unzip -qql "${archive}" | sed -r '1 {s/([ ]+[^ ]+){3}\s+//;q}')
            ctx logger info "Unzipping ${archive}"
            unzip ${archive}

            ctx logger info "Moving ${inner_name} to ${destination}"
            mv ${inner_name} ${destination}

        else

            # assuming tarball if the archive is not a zip.
            # we dont check that tar exists since if we made it
            # this far, it definitely exists (nodejs used it)
            inner_name=$(tar -tf "${archive}" | grep -o '^[^/]\+' | sort -u)
            ctx logger info "Untaring ${archive}"
            tar -zxvf ${archive}

            ctx logger info "Moving ${inner_name} to ${destination}"
            mv ${inner_name} ${destination}

        fi
    fi
}

TEMP_DIR='/tmp'
APPLICATION_URL=$(ctx node properties application_url)
AFTER_SLASH=${APPLICATION_URL##*/}
ARCHIVE_NAME=${AFTER_SLASH%%\?*}

# the folder that will contain the django project source
ROOT_PATH=~/djangosample
mkdir -p ${ROOT_PATH}

# download project archive to the temp dir
ctx logger info "going to download archive: ${APPLICATION_URL}"
cd ${TEMP_DIR}
download ${APPLICATION_URL} ${ARCHIVE_NAME}

# extract project files
SOURCE_PATH=${ROOT_PATH}/src
extract ${ARCHIVE_NAME} ${SOURCE_PATH}

# save the source path for future use
ctx instance runtime_properties source_path ${SOURCE_PATH}

ctx logger info "Sucessfully installed djangosample to ${SOURCE_PATH}"
