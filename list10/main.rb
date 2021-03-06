require 'selenium-webdriver'
require './homePage'
require './getData'
require 'tk'
require './createGraphs'
require 'thread'

class MyGUI

  # Initialize Gui
  def initialize
    @graph_creator = GraphCreator.new
    @root = TkRoot.new
    @root.title = "Currency Charts"
    @root.height = 550
    @root.width = 550
    @root.minsize(550,550)
    @root.maxsize(550,550)

    @menu = TkMenu.new
    @new_graph = TkMenu.new(@menu)

    @menu.add('cascade', :menu => @new_graph, :label => 'New Graph')
    @new_graph.add('command', :label => 'Enter Graph Range ',
                   :command => proc { add_date_range})
    @new_graph.add('command',:state =>"normal", :label => 'EUR -> USD',
                   :command => proc { eur_graph })
    @new_graph.add('command',:state =>"normal", :label => 'PLN -> USD',
                   :command => proc { pln_graph})

    @root.menu(@menu)
    Tk.mainloop
  end

  # Creates window for submiting date range
  def add_date_range
    @date_window = TkToplevel.new
    @date_window.title = "Date Range"

    @first_entry = TkEntry.new(@date_window)
    @first_entry.width = 30
    @first_entry.insert '0', "dd-mm-yyyy"
    @second_entry = TkEntry.new(@date_window)
    @second_entry.width = 30
    @second_entry.insert '0', "dd-mm-yyyy"
    @submit_button = TkButton.new(@date_window)
    @submit_button.text = "Submit"
    @submit_button.command = proc {submit_date_range}
    @first_entry.grid
    @second_entry.grid
    @submit_button.grid
  end

  # Submits date taken from entry labels
  def submit_date_range
    date_1 = @first_entry.get
    date_2 = @second_entry.get
    @date_window.destroy
    @graph_creator.set_date(date_1, date_2)
  end

  # Changes Chart Image
  def new_background(name)
    image = TkPhotoImage.new
    image.file = name
    label = TkLabel.new(@root)
    label.image = image
    label.place('x' => 25, 'y' => 25)
  end

  # Creates EUR>USD GRAPH
  def eur_graph
    @graph_creator.create_graph("eur")
    new_background("chart.png")
  end

  # Creates PLN>USD GRAPH
  def pln_graph
    @graph_creator.create_graph("pln")
    new_background("chart.png")
  end

end

my_gui = MyGUI.new
