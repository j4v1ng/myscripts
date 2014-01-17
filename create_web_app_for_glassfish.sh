echo -e "This script will help you create a JSF 2.2 web app compatible with Glassfish 4
application server.(Also the dependencies for the primefaces framework will be included)"
#Create first the basic webapp using the maven archetype
echo -e "STEP 1: provide a group id following the format part1.part2.part3:"
read groupId
echo -e "STEP 2: provide an artifact id(e.g my-webapp):"
read artifactId
echo -e "STEP 3: The web app will now be created(The project will be created at ~/Desktop)..."
mvn archetype:generate -DgroupId=${groupId} -DartifactId=${artifactId} -DarchetypeArtifactId=maven-archetype-webapp -Dversion=1
mv ${artifactId} ~/Desktop
#Create the java folder and the necessary subfolders inside it
subfoldersArray=(${groupId//./ })
cd ~/Desktop/${artifactId}/src/main
mkdir java
cd ~/Desktop/${artifactId}/src/main/java
mkdir ${subfoldersArray[0]}
cd ~/Desktop/${artifactId}/src/main/java/${subfoldersArray[0]}
mkdir ${subfoldersArray[1]}
cd ~/Desktop/${artifactId}/src/main/java/${subfoldersArray[0]}/${subfoldersArray[1]}
mkdir ${subfoldersArray[2]}
cd ~/Desktop/${artifactId}/src/main/java/${subfoldersArray[0]}/${subfoldersArray[1]}/${subfoldersArray[2]}
#Create the test folder
cd ~/Desktop/${artifactId}/src/
mkdir test
cd ~/Desktop/${artifactId}/src/test/
mkdir java
#Replace pom.xml
cd ~/Desktop/${artifactId}
rm pom.xml
pomXmlContent="<project xmlns=\"http://maven.apache.org/POM/4.0.0\"
         xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
         xsi:schemaLocation=\"http://maven.apache.org/POM/4.0.0
    http://maven.apache.org/maven-v4_0_0.xsd\">
    <modelVersion>4.0.0</modelVersion>
    <groupId>"${groupId}"</groupId>
    <artifactId>"${artifactId}"</artifactId>
    <packaging>war</packaging>
    <version>1.0-SNAPSHOT</version>
    <name>primefaces Maven Webapp</name>
    <url>http://maven.apache.org</url>

    <repositories>
        <repository>
            <id>prime-repo</id>
            <name>PrimeFaces Maven Repository</name>
            <url>http://repository.primefaces.org</url>
            <layout>default</layout>
        </repository>
    </repositories>

    <dependencies>

        <!-- PrimeFaces -->
        <dependency>
            <groupId>org.primefaces</groupId>
            <artifactId>primefaces</artifactId>
            <version>4.0</version>
        </dependency>

        <!-- JSF 2 -->
        <dependency>
            <groupId>com.sun.faces</groupId>
            <artifactId>jsf-api</artifactId>
            <version>2.2.4</version>
        </dependency>

        <dependency>
            <groupId>com.sun.faces</groupId>
            <artifactId>jsf-impl</artifactId>
            <version>2.2.4</version>
        </dependency>

        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>jstl</artifactId>
            <version>1.2</version>
        </dependency>

        <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>servlet-api</artifactId>
        <version>2.5</version>
        </dependency>

        <dependency>
            <groupId>javax.servlet.jsp</groupId>
            <artifactId>jsp-api</artifactId>
            <version>2.1</version>
        </dependency>

        <!-- EL -->
        <dependency>
            <groupId>org.glassfish.web</groupId>
            <artifactId>el-impl</artifactId>
            <version>2.2</version>
        </dependency>

    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>2.3.2</version>
                <configuration>
                    <source>1.6</source>
                    <target>1.6</target>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>"

echo ${pomXmlContent} > pom.xml
#Replace index page
indexXhtmlContent="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"
        \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">
<html xmlns=\"http://www.w3.org/1999/xhtml\"
      xmlns:h=\"http://xmlns.jcp.org/jsf/html\"
      xmlns:f=\"http://xmlns.jcp.org/jsf/core\"
      xmlns:ui=\"http://xmlns.jcp.org/jsf/facelets\"
      xmlns:p=\"http://primefaces.org/ui\">
<h:head>
</h:head>
<h:body>
    <h:form>
        Enter your name
        <h:inputText value=\"#{helloBean.input}\" />
        <h:commandButton value=\"submit\" action=\"#{helloBean.submit}\" />
    </h:form>
    <h:outputText value=\"#{helloBean.output}\" />
</h:body>
</html>"
cd ~/Desktop/${artifactId}/src/main/webapp
rm index.jsp
echo ${indexXhtmlContent} > index.xhtml
#Replace web.xml
webXmlContent="<web-app xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
         xmlns=\"http://java.sun.com/xml/ns/javaee\"
         xmlns:web=\"http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd\"
         xsi:schemaLocation=\"http://java.sun.com/xml/ns/javaee
    http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd\"
         id=\"WebApp_ID\" version=\"3.0\">

    <!-- Change to \"Production\" when you are ready to deploy -->
    <context-param>
        <param-name>javax.faces.PROJECT_STAGE</param-name>
        <param-value>Development</param-value>
    </context-param>

    <!-- Welcome page -->
    <welcome-file-list>
        <welcome-file>faces/index.xhtml</welcome-file>
    </welcome-file-list>

    <!-- JSF mapping -->
    <servlet>
        <servlet-name>Faces Servlet</servlet-name>
        <servlet-class>javax.faces.webapp.FacesServlet</servlet-class>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <!-- Map these files with JSF -->
    <servlet-mapping>
        <servlet-name>Faces Servlet</servlet-name>
        <url-pattern>/faces/*</url-pattern>
    </servlet-mapping>
    <servlet-mapping>
        <servlet-name>Faces Servlet</servlet-name>
        <url-pattern>*.jsf</url-pattern>
    </servlet-mapping>
    <servlet-mapping>
        <servlet-name>Faces Servlet</servlet-name>
        <url-pattern>*.faces</url-pattern>
    </servlet-mapping>
    <servlet-mapping>
        <servlet-name>Faces Servlet</servlet-name>
        <url-pattern>*.xhtml</url-pattern>
    </servlet-mapping>

</web-app>"
cd ~/Desktop/${artifactId}/src/main/webapp/WEB-INF
rm web.xml
echo ${webXmlContent} > web.xml
#Create faces-config.xml
facesConfigContent="<?xml version='1.0' encoding='UTF-8'?>
<faces-config version=\"2.2\"
              xmlns=\"http://xmlns.jcp.org/xml/ns/javaee\"
              xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
              xsi:schemaLocation=\"http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-facesconfig_2_2.xsd\">
</faces-config>"
facesConfigFileName="faces-config.xml"
cd ~/Desktop/${artifactId}/src/main/webapp/WEB-INF
echo ${facesConfigContent} > ${facesConfigFileName} 
# Create the backing bean
backingBeanContent="package ${subfoldersArray[0]}.${subfoldersArray[1]}.${subfoldersArray[2]};

import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;

@ManagedBean
@RequestScoped
public class HelloBean {

    private String input;
    private String output;

    public void submit() {
        output = String.format(\"Hello %s!\", input);
    }

    public String getInput() {
        return input;
    }

    public String getOutput() {
        return output;
    }

    public void setInput(String input) {
        this.input = input;
    }

}"
cd ~/Desktop/${artifactId}/src/main/java/${subfoldersArray[0]}/${subfoldersArray[1]}/${subfoldersArray[2]}/
echo ${backingBeanContent} > HelloBean.java 

#Cosas que hacer
echo -e "TO BE ABLE TO USE THIS PROJECT IN INTELLJ YOU WILL NEED TO SOURCE(Blue color folder) THE JAVA AND THE WEB-INF FOLDERS AFTER IMPORTING. ALSO Ctrl+Alt+L WILL BE NEEDED JUST TO FORMAT THE SOURCES"
