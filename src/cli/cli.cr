require "pdf"
require "option_parser"
require "xml"
require "./../caramel"

infile = STDIN
infilename = ""

outfile = STDOUT
outfilename = ""

format = "pdf"

OptionParser.parse! do |parser|
  parser.banner = "Usage: caramel -i infile=stdin -o outfile=stdout"
  parser.on("-i name", "read from this file") { |name| infilename = name }
  parser.on("-o name", "write to this file") { |name| outfilename = name }
  parser.on("-f format", "output format") { |f| format = f }
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

if infilename != ""
  infile = File.open(infilename, "r")
end

if outfilename != ""
  outfile = File.open(outfilename, "w")
end

case format
when "xml"
  doc = XML.parse(infile)
  Caramel.expand(doc, File.dirname(infilename), "styles", "src")
  Caramel::Widgets::Document.new(doc)
  outfile << doc
when "pdf"
  doc = Caramel::Widgets::Document.new(infile)
  wr = PDF::Writer.new(outfilename)
  doc.draw(wr)
  outfile << wr if outfilename == ""
end

infile.close
outfile.close
