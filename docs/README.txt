Application Programming Using Java Homework 5
Yichen Li
08/2020

# Introduction

This program is a web application that access a database for farmer market information.
User could query from an existing MySQL database and obtain records of farmer markets that
match his/her requested parameters.

# Prerequisite
Java EE
JDK 14.0.3 or higher  
JRE 14.0.3 or higher
Tomcat 9.0

# Notice
As a web application, the program cannot be started from scripts. Please refer to install.txt
for instructions on running the program.

# File directories
root
|-databases
|  |
|  |- databases and schemas
|
|-docs
|  |
|  |-README.txt
|  |
|  |-<generated javadoc files>
|
|-lib
|  |
|  |-servlet-api.jar
|
|-output
|
|-scripts
|  |
|  |-javadoc.sh
|  |
|  |-javadoc.cmd
|
|-src
|  |
|  |-main
|  |  |
|  |  |-java
|  |  |  |
|  |  |  |-*.java
|  |  |  
|  |  |-webapp
|  |  |  |
|  |  |  |-index.jsp
|  |  |  |
|  |  |  |-WEB-INF
|  |  |  |  |
|  |  |  |  |-lib/mysql-connector.jar
|
|-temp
|
|-tests
   |
   |-tests.pdf, screenshots of running results and schemas of databases


# Usage
Please refer to install.txt

The program will run automatically after setting up in Tomcat. User will
be prompted to choose parameters and query the data from database.

# Test
Please read ./docs/test.pdf for more details.
