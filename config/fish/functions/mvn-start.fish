function mvn-start --description 'clean dist and start the server'
  j ref; mvn clean; mvn tomcat:run;
end
