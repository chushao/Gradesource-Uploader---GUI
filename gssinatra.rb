# Chu Shao
# Jan 21st, 2013
# Gradesource Sinatra
# A Webbased uploader for the gradesource script


require 'sinatra'
require 'rupy'
require 'net/http'
require 'open-uri'
require 'zip/zip'
require 'haml'

# Updates to the most recent Gradesource script from Github
def updateGradesource 
  open('pythongradesource.zip', 'wb') do |fo|
    puts 'Downloading Gradesource Script from github...'
    fo.print open('https://github.com/chushao/Gradesource-Uploader/archive/master.zip').read
  end
  Zip::ZipFile.open('pythongradesource.zip') { |zip_file|
    zip_file.each { |f|
      f_path=File.join('./', f.name)
      zip_file.extract(f, f_path) { true }
    }
  }
end

# use a Python interpreter to do stuff.... because python FTW
def gradeSource(ver, login, courseID, assignmentID, password, overwrite)
  updateGradesource
  Rupy.start
  #Requires an adjustment to the library path
  sys = Rupy.import 'sys'
  p sys.path.append("./Gradesource-Uploader-master/")
  gs = Rupy.import 'gradesourceuploader'
  puts "about to upload"
  std_out = STDOUT.clone
  $stdout.reopen("my.log", "w")
  $stdout.sync = true
  $stderr.reopen($stdout)
  if ver == "1"
    if overwrite == "0"
      p gs.updateScoresByEmailGUI(login, courseID, assignmentID, './scores.csv', password, '0')
    else
      p gs.updateScoresByEmailGUI(login, courseID, assignmentID, './scores.csv', password, '1')
    end
  end
  if ver == "2"
    if overwrite == "0"
      p gs.updateScoresByPIDGUI(login, courseID, assignmentID, './scores.csv', password, '0')
    else
      p gs.updateScoresByPIDGUI(login, courseID, assignmentID, './scores.csv', password, '1')
    end
  end 
  if ver == "3" 
    p gs.downloadEmailGUI(login, courseID, password)
  end
  if ver == "4"  
    p gs.downloadiClickerGUI(login, courseID, password)
  end
  Rupy.stop
  $stdout.reopen(std_out)
  $stdout.sync = true
  $stderr.reopen($stdout)
end

get '/' do
  haml :index
end

post '/' do
  upload =  params['csvfile']
  login = params['login']
  password = params['password']
  courseID = params['courseID']
  assignmentID = params['assignmentID']
  return %[No username inputted. <a href="/">Try again?</a>] if login == ''
  return %[No password inputted. <a href="/">Try again?</a>] if password == ''
  return %[No courseID inputted. <a href="/">Try again?</a>] if courseID == ''
  if params[:function] == "1"
    return %[No file uploaded. <a href="/">Try again?</a>] if not upload
    return %[No assignmentID inputted. <a href="/">Try again?</a>] if assignmentID == ''
    File.open('./scores.csv', "w") do |f|
      f.write(params['csvfile'][:tempfile].read)
    end
    if params[:overwrite] == "0"
      gradeSource('1', login, courseID, assignmentID, password, '0')
    else
      gradeSource('1', login, courseID, assignmentID, password, '1')
    end
    redirect "/logs"
  end
  if params[:function] == "2"
    return %[No file uploaded. <a href="/">Try again?</a>] if not upload
    return %[No assignmentID inputted. <a href="/">Try again?</a>] if assignmentID == ''
    File.open('./scores.csv', "w") do |f|
      f.write(params['csvfile'][:tempfile].read)
    end
   if params[:overwrite] == "0"
      gradeSource('2', login, courseID, assignmentID, password, '0')
    else
      gradeSource('2', login, courseID, assignmentID, password, '1')
    end
    redirect "/logs"
  end
  if params[:function] == "3"
    gradeSource('3', login, courseID, "null", password, '1')
    send_file "./Roster.csv", :filename => 'Roster.csv', :type => 'Application/octet-stream'
    redirect "/logs"
  end
  if params[:function] == "4"
    gradeSource('4', login, courseID, "null", password, '1')
    send_file "./iClickerRoster.csv", :filename => 'iClickerRoster.csv', :type => 'Application/octet-stream'
    redirect "/logs"
  end
end

get '/logs' do
  results = File.read('./my.log')
  @logs = results
  haml :logs
end
