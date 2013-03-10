all: build deploy

rebuild:
	webdsl rebuild

deploy:
	webdsl deploy

build:
	webdsl build

clean:
	webdsl clean

css:
	cp stylesheets/*.css /opt/tomcat/webapps/WebLab/stylesheets

test:
	webdsl test WebLab
	
server:
	webdsl cleanall war

rdeploy:
	scp weblab.war eelcovisser@department.st.ewi.tudelft.nl:/home/eelcovisser/weblab
