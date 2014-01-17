#Where the workspace is located at ~/
PATH_TO_WORKSPACE="workspace_ultimate"
#Where a fresh copy of the glassfish app server can be found at ~/
PATH_TO_ORIGINAL_GLASSFISH_APPSERVER="glassfish4"
#Welcome message
echo -e "This tool will create a binary interface for your project"
echo -e "The current workspace is located at " $PATH_TO_WORKSPACE
#Gather the name of the project folder
echo -e "\n\nEnter the name of the folder whre your project is:"
read folderName
echo -e "Binary interface for " $folderName " will be created."
#Compiling the project
cd ~/$PATH_TO_WORKSPACE/$folderName
echo -e "STEP 1: COMPILE..."
mvn clean install
#Cleaning the project(releases space)
echo -e "STEP 2: CLEAN THE PROJECT..."
mvn clean
#Create a package
echo -e "STEP 3: PACK THE PROJECT":
mvn package
#Navigate to the target folder
cd ~/$PATH_TO_WORKSPACE/$folderName/target
#Rename the folder to remove the postfix SNAPSHOT
remove_extention="-1.0-SNAPSHOT.war"
oldExecutableName=${folderName}${remove_extention}
addExtention=".war"
echo "STEP 4: RENAMING DEPLOYMENT FILE" 
mv -vf $oldExecutableName ${folderName/$remove_extention/}${addExtention}
#Go to the desktop and create a folder where we will put all we need
cd ~/Desktop
mkdir ${folderName}
cd ${folderName}
#copy the application server(Glassfish)
echo "STEP 5: COPYING THE APP SERVER TO ~/Desktop/"${folderName}"(please wait)" 
cp -r ~/glassfish4 ~/Desktop/${folderName}
#Include also the .war into the folder but not into the appserver(that will be done with the
#deploy command latter)
echo "STEP 6: COPY EXECUTABLE TO THE .war TO THE FOLDER"
cp ~/${PATH_TO_WORKSPACE}/${folderName}/target/${folderName}.war ~/Desktop/${folderName}/
#Create start script
echo "STEP 7: CREATE SERVER START SCRIPT"
cat > start.sh <<EOF
echo "STARTING GLASSFISH PLEASE WAIT"
cd glassfish4/bin
chmod +x asadmin
./asadmin start-domain
deploy ${folderName}.war
#In order to work it is required that the original folder of glassfish don't contain already any #project, otherwise, there will be a conflict"
EOF
#Create deploy script
echo "STEP 8: CREATE DEPLOY SCRIPT"
cat > deploy.sh <<EOF
cd glassfish4/bin
chmod +x asadmin
./asadmin deploy ../../${folderName}.war
EOF
#Create stop script
echo "STEP 9: CREATE STOP SCRIPT"
cat > stop.sh <<EOF
echo "STOPING GLASSFISH PLEASE WAIT..."
cd glassfish4/bin
chmod +x asadmin
./asadmin stop-domain
#In order to work it is required that the original folder of glassfish don't contain already any #project, otherwise, there will be a conflict
EOF
#Make the scripts executable
chmod +x start.sh
chmod +x deploy.sh
chmod +x stop.sh
