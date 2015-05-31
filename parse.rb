require 'rexml/document'
require 'pp'

def miparse(fname, keytext, table)
	doc = REXML::Document.new(open(fname))
	doc.elements.each('table/tr') do |el|
		position = el.elements["td[1]"].text
		country  = el.elements["td[2]"].text
		sailno   = el.elements["td[3]"].text
		skipper  = el.elements['td[4]/a[1]'].text
		if (el.elements['td[4]/a[2]']) then
			crew = el.elements['td[4]/a[2]'].text
		end

		sailno.match(/(\w{3})\s*(\d+)/) do |md|
			sailno = sprintf("%s-%03d", md[1], md[2].to_i)
		end
		if (table[skipper].nil?) then
			table[skipper] = {:country => country, :sailno => sailno}
		else
			table[skipper][:sailno] = sailno
		end
		table[skipper][keytext] = position.to_i;
	end
end

def gaparse(fname, keytext, table)
	File.readlines(fname).each do |line|
		line.chomp!
		ary = line.split(/\t/)
		position = ary[0]
		country  = ary[1]
		sailno   = ary[2]
		skipper  = ary[3]
		crew     = ary[4]

		sailno.match(/(\w{3})\s*(\d+)/) do |md|
			sailno = sprintf("%s-%03d", md[1], md[2].to_i)
		end
		if (table[skipper].nil?) then
			table[skipper] = {:country => country, :sailno => sailno}
		else
			table[skipper][:sailno] = sailno
		end
		table[skipper][keytext] = position.to_i;
	end
end

def dlparse(fname, keytext, table)
	doc = REXML::Document.new(open(fname))
	doc.elements.each('table/tr') do |el|
		position = el.elements["td[1]"].text
		country  = el.elements["td[2]"].text
		sailno   = el.elements["td[3]"].text
		skipper  = el.elements['td[4]/a[1]'].text
		crew     = el.elements['td[5]/a[1]'].text

		sailno.match(/(\w{3})\s*(\d+)/) do |md|
			sailno = sprintf("%s-%03d", md[1], md[2].to_i)
		end
		skipper.match(/^([A-Z]+) ([A-Z][a-z]+)$/) do |md|
			skipper = md[2] + " " + md[1].capitalize
		end
		skipper.match(/^([A-Z]+) ([A-Z]+) ([A-Z][a-z]+)$/) do |md|
			skipper = md[3] + " " + md[1].capitalize + " " + md[2].capitalize
		end
		skipper.match(/^([A-Z]+) ([A-Z][a-z]+) ([A-Z][a-z]+)$/) do |md|
			skipper = md[2] + " " + md[3] + " " + md[1].capitalize
		end
		skipper.match(/^([A-Z]+) ([A-Z][a-z]+) ([A-Z][a-z]+) ([A-Z][a-z]+)$/) do |md|
			skipper = md[2] + " " + md[3] + " " + md[4] + " " + md[1].capitalize
		end

		skipper = "Ben Saxton" if (skipper == "Benjamin Saxton")
		skipper = "Ingrid Petitjean" if (skipper == "Ingrid Petitjean Backes")
		skipper = "Matías Bühler" if (skipper == "Matias Buhler")
		skipper = "Renee Groeneveld" if (skipper == "Renee Groenveld")
		skipper = "Sergey Dzhienbaev" if (skipper == "Sergey Dzhenbaev")
		skipper = "Nicole van der Velden" if (skipper == "van der VELDEN Nicole")
		skipper = "Clinio Marcelino de Freitas Neto" if (skipper == 'FREITAS Clinio de')

		country.match(/&nbsp;([A-Z]{3})/) do |md|
			country = md[1]
		end
		if (table[skipper].nil?) then
			table[skipper] = {:country => country, :sailno => sailno}
		else
			table[skipper][:sailno] = sailno
		end
		table[skipper][keytext] = position.to_i;
	end
end

def csvparse(fname, keytext, table)
	File.readlines(fname).each do |line|
		line.chomp!
		ary = line.split(/,/)
		position = ary[0]
		country  = ary[1]
		sailno   = ary[1] + "-" + ary[2]
		skipper  = ary[3] + " " + ary[4]
		if (ary.size > 5) then
			crew = ary[5] + " " + ary[6]
		end

		sailno.match(/(\w{3})\s*(\d+)/) do |md|
			sailno = sprintf("%s-%03d", md[1], md[2].to_i)
		end
		if (table[skipper].nil?) then
			table[skipper] = {:country => country, :sailno => sailno}
		else
			table[skipper][:sailno] = sailno
		end
		table[skipper][keytext] = position.to_i;
	end
end

def isaf_parse(fname, keytext, table)
	doc = REXML::Document.new(open(fname))
	doc.elements.each('table/tr') do |el|
		position = el.elements["td[1]"].text
		country  = el.elements["td[2]"].text
		sailno   = el.elements["td[3]"].text
		skipper  = el.elements['td[6]/a[1]'].text
		if (el.elements['td[6]/a[2]']) then
			crew = el.elements['td[6]/a[2]'].text
		end

		skipper = "Matías Bühler" if (skipper == "Matías Bühler Matías")
		skipper = 'Robert Daniel' if (skipper == 'Robbie Daniel Daniel')
		skipper = 'Andre Mirsky' if (skipper == 'Andre MIRSKY')

		sailno.match(/(\w{3})\s*(\d+)/) do |md|
			sailno = sprintf("%s-%03d", md[1], md[2].to_i)
		end
		if (table[skipper].nil?) then
			table[skipper] = {:country => country, :sailno => sailno}
		else
			table[skipper][:sailno] = sailno
		end
		table[skipper][keytext] = position.to_i;
	end
end

def isaf2_parse(fname, keytext, table)
	doc = REXML::Document.new(open(fname))
	doc.elements.each('table/tr') do |el|
		position = el.elements["td[1]"].text
		country  = el.elements["td[2]"].text
		sailno   = el.elements["td[3]"].text
		skipper  = el.elements['td[4]/div[1]/a[1]'].text
		if (el.elements['td[4]/div[2]/a[1]']) then
			crew = el.elements['td[4]/div[2]/a[1]'].text
		end

		if (skipper == 'Matías Bühler Matías') then
			skipper = 'Matías Bühler'
		end

		sailno.match(/(\w{3})\s*(\d+)/) do |md|
			sailno = sprintf("%s-%03d", md[1], md[2].to_i)
		end
		if (table[skipper].nil?) then
			table[skipper] = {:country => country, :sailno => sailno}
		else
			table[skipper][:sailno] = sailno
		end
		table[skipper][keytext] = position.to_i;
	end
end

def eurosaf_parse(fname, keytext, table)
	doc = REXML::Document.new(open(fname))
	doc.elements.each('table/tr') do |el|
		position = el.elements["td[1]"].text
		sailno   = el.elements["td[2]"].text
		skipper  = el.elements["td[5]"].text
		crew  = el.elements["td[6]"].text

		skipper = 'Lin Ea Cenholt Christiansen' if (skipper == 'Lin Ea Cenholt Christiansen CENHOLT CHRISTIANSEN')	
		skipper = 'Euan McNicol' if (skipper == 'Euan Witton MCNICOL')
		skipper = 'Fernando Echávarri' if (skipper == 'Fernando ECHAVARRI ERASUN')
		skipper = 'Allan Norregaard' if (skipper == 'Allan NØRREGAARD')
		skipper = 'Matías Bühler' if (skipper == 'Matias BÜHLER')
		skipper = 'Federica Salvà' if (skipper == 'Federica SALVÀ')
		skipper = 'Nicole van der Velden' if (skipper == 'Nicole VAN DER VELDEN')
		skipper = 'Jeremy Wilmot' if (skipper == 'Jeremy  Wilmot')
		skipper = 'Maxim Semenov' if (skipper == 'Maksim SEMENOV')
		skipper = 'Morgan Good' if (skipper == 'Good MORGAN')

		skipper.match(/^([A-Z][a-z]+) ([A-Z]+)$/) do |md|
			skipper = md[1] + " " + md[2].capitalize
		end
		skipper.match(/^([A-Z][a-z]+) ([A-Z][a-z]+) ([A-Z]+)$/) do |md|
			skipper = md[1] + " " + md[2].capitalize + " " + md[3].capitalize
		end

		country = ''
		sailno.match(/(\w{3})\s*(\d+)/) do |md|
			country = md[1]
			sailno = sprintf("%s-%03d", md[1], md[2].to_i)
		end
		if (table[skipper].nil?) then
			table[skipper] = {:country => country, :sailno => sailno}
		else
			table[skipper][:sailno] = sailno
		end
		table[skipper][keytext] = position.to_i;
	end
end

def eurosaf2_parse(fname, keytext, table)
	doc = REXML::Document.new(open(fname))
	doc.elements.each('table/tr') do |el|
		position = el.elements["td[1]"].text
		sailno = el.elements["td[3]"].texts[1].to_s
		skipper   = el.elements["td[4]/div[1]/a[1]"].text

		skipper = 'Lin Ea Cenholt Christiansen' if (skipper == 'Lin Ea CENHOLT')	
		skipper = 'Euan McNicol' if (skipper == 'McNicol EUAN')
		skipper = 'Nicole van der Velden' if (skipper == 'Nicole van der VELDEN')
		skipper = 'Tat Choi Fung' if (skipper == 'FUNG Tat Choi')
		skipper = 'Allan Norregaard' if (skipper == 'Allan NØRREGAARD')
		skipper = 'Matías Bühler' if (skipper == 'Matias BÜHLER')
		skipper = 'Maxim Semenov' if (skipper == 'Maksim SEMENOV')

		skipper.match(/^([A-Z][a-z]+) ([A-Z]+)$/) do |md|
			skipper = md[1] + " " + md[2].capitalize
		end
		skipper.match(/^([A-Z][a-z]+) ([A-Z][a-z]+) ([A-Z]+)$/) do |md|
			skipper = md[1] + " " + md[2].capitalize + " " + md[3].capitalize
		end
		skipper = 'Federica Salvà' if (skipper == 'Federica Salva')
		skipper = 'Iker Martinez de Lizarduy' if (skipper == 'Iker Martinez')
		skipper = 'Pablo Defazio Abella' if (skipper == 'Pablo Defazio')

		country = ''
		sailno.match(/(\w{3})\s*(\d+)/) do |md|
			country = md[1]
			sailno = sprintf("%s-%03d", md[1], md[2].to_i)
		end
		if (table[skipper].nil?) then
			table[skipper] = {:country => country, :sailno => sailno}
		else
			table[skipper][:sailno] = sailno
		end
		table[skipper][keytext] = position.to_i;
	end
end

table = {}
miparse("results/melbourne_2013.html", :MEL2013, table)
miparse("results/miami_2014.html", :MIA2014, table)
miparse("results/mallorca_2014.html", :MAL2014, table)
miparse("results/hyeres_2014.html", :HYE2014, table)
gaparse("results/garda_2014.tsv", :GAR2014, table)
dlparse("results/delta_lloyd_2014.html", :DEL2014, table)
gaparse("results/sail_for_gold_2014.tsv", :SFG2014, table)
csvparse("results/kieler_2014.csv", :KIE2014, table)
csvparse("results/European_2014.csv", :EUR2014, table)
isaf_parse("results/santander_2014.html", :SAN2014, table)
isaf_parse("results/melbourne_2014.html", :MEL2014, table)
isaf_parse("results/miami_2015.html", :MIA2015, table)
eurosaf_parse("results/mallorca_2015.html", :MAL2015, table)
isaf2_parse("results/hyeres_2015.html", :HYE2015, table)
eurosaf2_parse("results/delta_lloyd_2015.html", :DEL2015, table)

column = ["NAME", "COUNTRY", "SAILNO",
	"MEL", "MIA", "MAL", "HYE", "GAR", "DEL", "SFG", "KIE", "EUR", "SAN",
	"MEL2014", "MIA2015", "MAL2015", "HYE2015", "DEL2015"]
fmt = (["%s"] * column.length).join("\t") + "\n";
printf(fmt, *column)
fmt = (["%s"] * column.length).join("\t") + "\n"

table.each do |key, val|
	printf(fmt,
		key,
		val[:country],
		val[:sailno],
		val[:MEL2013].nil? ? -1 : val[:MEL2013],
		val[:MIA2014].nil? ? -1 : val[:MIA2014],
		val[:MAL2014].nil? ? -1 : val[:MAL2014],
		val[:HYE2014].nil? ? -1 : val[:HYE2014],
		val[:GAR2014].nil? ? -1 : val[:GAR2014],
		val[:DEL2014].nil? ? -1 : val[:DEL2014],
		val[:SFG2014].nil? ? -1 : val[:SFG2014],
		val[:KIE2014].nil? ? -1 : val[:KIE2014],
		val[:EUR2014].nil? ? -1 : val[:EUR2014],
		val[:SAN2014].nil? ? -1 : val[:SAN2014],
		val[:MEL2014].nil? ? -1 : val[:MEL2014],
		val[:MIA2015].nil? ? -1 : val[:MIA2015],
		val[:MAL2015].nil? ? -1 : val[:MAL2015],
		val[:HYE2015].nil? ? -1 : val[:HYE2015],
		val[:DEL2015].nil? ? -1 : val[:DEL2015],
	)
end
