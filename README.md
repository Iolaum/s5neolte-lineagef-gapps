# s5neolte-lineagef-gapps
Building a fork of LineageOS with gapps for Galaxy S5 Neo

## Custom Build Instructions

We will use the [docker image provided by the lineageos4microg team](https://github.com/lineageos4microg/docker-lineage-cicd) and alter accordingly the instructions provided.

## Custom Userscripts:

The custom userscripts that our container image will support are described below:

- `/root/userscripts/begin.sh` | Runs at start.
- `/root/userscripts/before.sh` | Runs after `build\envsetup.sh`
- `/root/userscripts/pre-build.sh` | Runs right before build starts.
- `/root/userscripts/post-build.sh` | Runs after build
- `/root/userscripts/end.sh` | Runs at the end

## Re-building for Galaxy S5 Neo

As there is no official support for this device, we first have to include the sources in the source tree through an XML in the 
manifests folder. We will use repositories from the [Exynos7580](https://gitlab.com/Exynos7580/) team.

We also set INCLUDE_PROPRIETARY=false, as the proprietary blobs are already
provided by the vendor repositories (so we don't have to include the TheMuppets repo).

We add a [repository for custom pre-built packages](https://github.com/Iolaum/android_prebuilts_prebuiltapks). 
- Added MatLog Libre app to help with capturing logs. In this case as well the app needs an extra permission through adb, it's easier to include it in the build. Downloaded the app from fdroid's website.
- Added Fdroid and FDroidPriviligedExtension

We add a repository that includes the bromite system webview which is more privacy friendly than android's default chromium webview.

We make the necessary changes to incude the opengapps packages according to the instructions found [here](https://github.com/opengapps/aosp_build/blob/master/README.md).

We add all the needed repositories in our `s5neolte.xml` file and we move the manifest file to `/home/$USER/lineageos/manifests`.
We also add our custom script to `/home/$USER/lineageos/userscripts/`.

Now we can create our build

```
$ sudo docker run \
     -e "BRANCH_NAME=lineage-15.1" \
     -e "DEVICE_LIST=s5neolte" \
     -e "SIGN_BUILDS=true" \
     -e "CUSTOM_PACKAGES=FDroid FDroidPrivilegedExtension MatLog" \
     -e "INCLUDE_PROPRIETARY=false" \
     -v "/home/$USER/lineageos/src:/srv/src" \
     -v "/home/$USER/lineageos/zips:/srv/zips" \
     -v "/home/$USER/lineageos/logs:/srv/logs" \
     -v "/home/$USER/lineageos/ccache:/srv/ccache" \
     -v "/home/$USER/lineageos/keys:/srv/keys" \
     -v "/home/$USER/lineageos/manifests:/srv/local_manifests" \
     -v "/home/$USER/lineageos/userscripts:/srv/userscripts" \
     -e "RELEASE_TYPE=SISYPHUS" \
     -e "USER_NAME=Nikolaos Perrakis" \
     -e "USER_MAIL=nikperrakis@gmail.com" \
     -e "KEYS_SUBJECT=/C=UK/L=Nottingham/O=LineageOS/emailAddress=nikperrakis@gmail.com" \
     lineageos4microg/docker-lineage-cicd

```

The [resulting image]() can uploaded to androidfilehost.

## Things to update when re-building

- Check for new BromiteWebview release.
- Check that latest android security update has been merged in LineageOS repositories.
- Update pre-built apk's to latest versions.

## Helpful commands:

- Removing repo locks if connection is lost and sync fails:
```
# Run within source directory!
$ sudo find ./ -name *lock* -exec rm {} \;
# add command to custom script?
```

- Docker related commands:
```
# Start docker service
$ sudo systemctl start docker
# stop all running docker images
$ sudo docker stop $(sudo docker ps -a -q)
# delete all running docker images
$ sudo docker rm $(sudo docker ps -a -q)
```


