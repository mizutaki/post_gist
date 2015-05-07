require 'tk'
require 'tkextlib/tkDND'
require_relative 'gist'

Tk::TkDND::DND

puts Tk::TkDND::DND.version

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
      gist.create_gist(file_name, file.read)
    end
	}
	pack
}
Tk.root.resizable(0, 0)#window�T�C�Y�̌Œ�

Tk.mainloop
