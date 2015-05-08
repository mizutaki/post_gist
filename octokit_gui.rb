require 'tk'
require 'tkextlib/tkDND'
require_relative 'gist'

Tk::TkDND::DND

puts Tk::TkDND::DND.version

root = TkRoot.new(:title=>"input sample")
#TkButton.new(nil, :text => "exec", :command => proc{ sayHello(@text.value) }).pack        
#TkButton.new(nil, :text => "finish", :command => proc{ exit }).pack
file_description = ""
Tk.root.title("gist")#window title
label = TkLabel.new{
	text "ココにファイルをDROPしてください"
	fg 'blue' #text color
	bg 'white'#background color
	width 50
	height 10
	
  dnd_bindtarget('text/uri-list', '<Drop>', '%D'){|event|
    file_path = event[0]
    gist = Gist.new
    File.open(file_path, 'r') do |file|
      file_name=File::basename(file.path)
      gist.create_gist(file_name, file.read, file_description)
    end
	}
	pack
}

label = TkLabel.new{
  text "Please File Description!!"
  pack
}
file_description = TkEntry.new.pack

label = TkLabel.new.pack

Tk.root.resizable(0, 0)#window�T�C�Y�̌Œ�

Tk.mainloop
