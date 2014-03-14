Gradesource-Uploader---GUI
==========================

Gui frontend of gradesource uploader.
  
This application was written in Ruby and uses the Sinatra web-framework.  
Currently due to an issue with LLVM/Clang (Xcode compiler), this application cannot be ran in Mac OSX.  
However, it runs well in cloud services such as dotcloud, and Linux Distros such as CentOS and Ubuntu.  


Heroku Version:
http://gradesource-uploader.herokuapp.com/

Requirements:  
Bundler => http://www.gembundler.com  
Ruby 1.9.3 => http://www.ruby-lang.org/  
Python 2.7 => http://www.python.org/ ** NOTE CANNOT BE PYTHON 3.0 OR HIGHER  

To install:  
cd into the directory of gssinatra.rb  
  
gem install bundler   
bundle install   
ruby gssinatra.rb   
  
this application uses https://github.com/chushao/Gradesource-Uploader/ as it's underlying structure.
