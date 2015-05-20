require 'tk'
require 'tkextlib/tkDND'
require_relative 'gist'

Tk::TkDND::DND

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
    u8str = event[0].encode("iso-8859-1", "utf-8").encode("iso-8859-1", "utf-8")
    file_path = u8str.encode('cp932', 'utf-8')
    gist = Gist.new
    File.open(file_path, 'r') do |file|
      file_name=File::basename(file.path)
      gist.create_gist(file_name, file.read, file_description.value)
    end
	}
	pack
}

label = TkLabel.new{
  text "Please File Description!!"
  pack
}

file_description = TkText.new do
  width(70)
  height(15)
  pack('side' => 'top', 'fill' => 'both')
end
label = TkLabel.new.pack

Tk.root.resizable(0, 0)#window�T�C�Y�̌Œ�

Tk.mainloop
