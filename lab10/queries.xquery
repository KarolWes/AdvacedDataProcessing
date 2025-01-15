(:5.:)
for $b in doc("db/bib/bib.xml")//book
return $b/author/last

(:6.:)
for $b in doc("db/bib/bib.xml")//book
return
<ksiazka>
  {$b/author}
  {$b/title}
</ksiazka>

(:7.:)
for $b in doc("db/bib/bib.xml")//book
let $author := $b/author
return
<ksiazka>
  <autor>{concat($author/last, $author/first)}</autor>
  <tytul>{$b/title}</tytul>
</ksiazka>

(:8.:)
for $b in doc("db/bib/bib.xml")//book
let $author := $b/author
return
<ksiazka>
  <autor>{concat($author/last, ' ', $author/first)}</autor>
  <tytul>{$b/title}</tytul>
</ksiazka>

(:9.:)
<wynik>
{
for $b in doc("db/bib/bib.xml")//book
let $author := $b/author
return
<ksiazka>
  <autor>{concat($author/last, $author/first)}</autor>
  <tytul>{$b//title}</tytul>
</ksiazka>
}
</wynik>

(:10.:)
<imiona>
{
  for $b in doc("db/bib/bib.xml")//book
  for $name in $b/author/first
  where $b/title =  "Data on the Web"
  return <imie>{string($name)}</imie>
}</imiona>

(:11.:)
<DataOnWeb>
{
  for $b in doc("db/bib/bib.xml")//book
  where $b//title = "Data on the Web"
  return $b
}
</DataOnWeb>

<DataOnWeb>
{
  for $b in doc("db/bib/bib.xml")//book[title = "Data on the Web"]
  return $b
}
</DataOnWeb>

(:12.:)
<Data>
{
  for $b in doc("db/bib/bib.xml")//book
  for $name in $b//last
  where contains($b/title, "Data" )
  return <nazwisko>{string($name)}</nazwisko>
}
</Data>

(:13.:)
for $b in doc("db/bib/bib.xml")//book
where contains($b/title, "Data" )
return
<Data>
    {$b/title}
    {
        for $name in $b//first
        return <nazwisko>{string($name)}</nazwisko>
    }

</Data>

(:14.:)
for $b in doc("db/bib/bib.xml")//book
where count($b/author) <= 2
return
   $b/title

(:15.:)
for $b in doc("db/bib/bib.xml")//book
return
<ksiazka>
    {$b/title}
    <autorow>{count($b/author)}</autorow>
</ksiazka>

(:16.:)
let $b := doc("db/bib/bib.xml")//book
let $years := $b/@year
return
<przedzial>
  {min($years)} - {max($years)}
</przedzial>

(:17.:)
let $b := doc("db/bib/bib.xml")//book
let $p := $b/price
return
<roznica>
  {max($p) - min($p)}
</roznica>

(:18.:)
let $b := doc("db/bib/bib.xml")//book
let $cheapest := min($b/price)
for $books in doc("db/bib/bib.xml")//book
    where $books/price = $cheapest
    return
<najtansze>
  <najtansza>
  {$books/title}
  {
    for $author in $books//author
    return $author
  }
  </najtansza>
</najtansze>

(:19.:)
for $author in distinct-values(//author)
let $a := normalize-space($author)
return
<author>
{$a}
{
  for $book in doc("db/bib/bib.xml")//book
  for $bookAuth in $book/author
  let $name := $bookAuth/last || ' ' || $bookAuth/first
  where $name = $a
  return
  $book/title
}
</author>

(:20.:)
<wynik>
{
  for $b in collection("db/shakespeare")//PLAY/TITLE
  return
  $b
}
</wynik>

(:21.:)
for $b in collection("db/shakespeare")//PLAY
for $line in $b//LINE
where contains($line, "or not to be" )
return
$b/TITLE

(:22.:)
<WYNIK>
{
  for $b in collection("db/shakespeare")//PLAY
  return
  <sztuka title="{$b/TITLE}">
    <postaci>{count($b//PERSONA)}</postaci>
    <aktow>{count($b//ACT)}</aktow>
    <scen>{count($b//SCENE)}</scen>
  </sztuka>

}
</WYNIK>