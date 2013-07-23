-- Variablen sind generell global
globalerText 	= 'ein spannender Text'
globalerInt 	= 1
globalerFloat 	= 1.234

-- Um Variablen lokal zu machen setzt man
-- einfach ein local davor
local lokalerText 	= 'ein spannender Text'
local lokalerInt 	= 1
local lokalerFloat 	= 1.234

-- Arrays und Dictionarys heißen Tabellen
table = {}
-- ACHTUNG: erster Eintrag bei 1
table[1] = 'text'
table[2] = 12

sameTable = {'text', 12}

dictionary = {}
dictionary['tier'] = 'Hund'
dictionary['alter'] = 2

sameDictionary = {'tier' = 'Hund', 'alter' = 2}

-- Unterscheidungen sind auch sehr eingängig
if something ~= somethingElse then
	-- mach was
end

-- Natürlich geht das auch mit else 
if someInt > otherInt then
	-- mach was
else if someInt == otherInt then
	-- mach was anderes
else
	-- mach was ganz anderes
end

-- Schleifen
-- for i = [start],[ende],[schritt]
for i=1,10,2 do
	print(i)
end

-- while
i = 1
while i  <= 5 do
	 print (i)
	 i = i + 1
end

-- foreach über ein Dictonary
for key,value in pairs(tabelle) do
	print(key,value)
end

-- foreach über ein Array
for i,value in ipairs(tabelle) do
	print(i,value)
end
