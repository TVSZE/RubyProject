##FELTEVÉSEK

Ez a segédlet az alábbiakat feltételezi:
* Már telepítetted a rubyt
* Van github fiókod
  * SSH pub key hozzá adva a fiókhoz
* Már van rubygems.org fiókod

##BEVEZETÉS

Gemek készítése és publikálása nagyon könnyű a RubyGemsbe integrált eszközöknek köszönhetően. Csináljunk egy egyszerű „hello world” gemet. A gem kódja elérhető a [GitHub](https://github.com/TVSZE/RubyProject) is.

Amennyiben a segédletet Windows alatt követed, akkor ne feletkezz meg az „Administrator: Start Command prompt with Ruby”-t használni.
 
---

##AZ ELSŐ GEMED

A **hello** gememet a gemsepecn kívül csak egy fájllal kezdtem. A tied publikálásához szükséged lesz egy új névre (talán **hello_atefelhasznaloneved** az én esetemben **hello_tvsze**). Az alábbi javaslatok nyújtanak útmutatást [Patterns guide](http://guides.rubygems.org/patterns/#consistent-naming) a gemek elnevezésében.

```
% tree
.
├── hello_tvsze.gemspec
└── lib
    └── hello_tvsze.rb
```

A csomagod kódja a lib könyvtárba kerül. A szokás az hogy a Ruby fájloknak ugyan az a nevük mint a gemednek, mivel a require **'hello_tvsze'** futtatásakor ez töltődik be. Ez a fájl felelős a gemed API jának és kódjának a felkészítéséért.

A **lib/hello_tvsze.rb** -ban található kód elég csupasz. Jelenleg csak arra szolgál, hogy valami kimentet mutasson.
 
```ruby
% cat lib/hello_tvsze.rb
class Hello_tvsze
  def self.hi
    puts "Hello world!"
  end
end
```

A gemspec definiálja, hogy mi van a gemben, ki készítette és a verzió szám. Ez az interface a RubyGems.org felé. Minden információ amit egy gem oldalon találsz ( mint a jekyllé ) a gemspecből származik.

```ruby
% cat hello_tvsze.gemspec
Gem::Specification.new do |s|
  s.name        = 'hello_tvsze'
  s.version     = '0.0.0'
  s.date        = '2014-11-29'
  s.summary     = "Hello world gem!"
  s.description = "A simple hello world gem"
  s.authors     = ["Varga Tamas"]
  s.email       = 'varga.tamas.8@inf.u-szeged.hu'
  s.files       = ["lib/hello_tvsze.rb"]
  s.homepage    =
      'https://github.com/TVSZE/RubyProject'
  s.license       = 'MIT''
end
```
>A description tag lehet soggal hosszabb is mint ebben a példában. Amennyiben illeszkedik a /^== [A-Z]/ mintára, akkor a leírás át lesz eresztve az RDoc markup formázóján. Jó azt azért szem előtt tartani, hogy nem mindenhol fogják ezt az adatot hasonlóan feldolgozni.


Ismerősnek tűnik? A gemspec is Rubyban van, így scriptekkel generálható a fájl név és a verzió szám. A gemspec rengteg mezőt tartalmazhat. A teljes liste elérhető itt: [reference](http://guides.rubygems.org/specification-reference).

Miután létrehoztad a gemspect, buildelhet a gemet belőle. Majd helyileg telepítheted azt kipróbálás céljából.

```
% gem build hello_tvsze.gemspec
  Successfully built RubyGem
  Name: hello_tvsze
  Version: 0.0.0
  File: hello tvsze-0.0.0.gem

% gem install ./hello_tvsze-0.0.0.gem
Successfully installed hello_tvsze-0.0.0
Parsing documentation for hello_tvsze-0.0.0
Installing ri documentation for hello_tvsze-0.0.0
Done installing documentation for hello_tvsze after 0 seconds
1 gem installed
```

Természetesen az igaz teszt az hogy **require** -al használjuk a gemet:

```
% irb
>> require 'hello_tvsze'
=> true
>> Hello_tvsze.hi
Hello world!
```

>Amennyiben 1.9.2 –nél régebbi Rubyt használsz akkor a sessiont **irb -rubygems** val kell indítani, vagy az után kell a reubygems libraryt requirelni miután elindítottad az irbt.

Most már megoszthatod a hello_tvsze a Ruby közösséggel. A gemed RubyGems.org –on való publikálása csak egy parancsba kerül, feltéve hogy már van egy fiókod az oldalon. Az alábbit tedd ahhoz hogy előkészítsd a géped a RubyGems fiókod használatához:

```
$ curl -u qrush https://rubygems.org/api/v1/api_key.yaml >
%USERPROFILE%/.gem/credentials

Enter host password for user 'TVSZE':
```

>Amennyiben problémád van a curl, OpenSSL vagy bizonyítványok valamelyikével akkor lehet hogy egyszerűbb a fenti URL-t csak simán a böngésződbe írni. Ekkor a böngésző felkér a bejelentkezésre, majd letölti az api_key.yaml fájlt. Mentsd el a ~/.gem könyvtárban és nevezd át ‘credentials’-ra.

Miután a fentieket megtetted, feltolhatod (push) a gemet:
```
% gem push hello_tvsze-0.0.0.gem
Pushing gem to https://rubygems.org...
Successfully registered gem: hello_tvsze (0.0.0)
```

Lehetséges, hogy az alábbi hibába futsz
```
ERROR:  While executing gem ... (Gem::RemoteFetcher::FetchError)
    SocketError: getaddrinfo: No such host is known.  (http://rubygems.org/quick
/Marshal.4.8/rubygems-update-2.4.4.gemspec.rz)
```

Ez elég sok mindent takarhat, de a legáltalánosabb az hogy a géped nem tudja kinzisztensen felvenni a kapcsolatot a rubygems.org –al. A legjobb tanácsa amit adhatok, az az hogy próbáld meg újra később.
 
Ha sikeres volt a push, kis idő mulva (általában kevesebb mint  egy perc) a gemed telepíthető lesz bárki által. Megnézheted a [RubyGems.org oldalon](https://rubygems.org/gems/hello_tvsze) vagy letöltheted bármelyik számítógéppel amin van RubyGems:
```
% gem list -r hello_tvsze

*** REMOTE GEMS ***

hello_tvsze (0.0.0)

% gem install hello_tvsze
Successfully installed hello_tvsze-0.0.0
1 gem installed
Installing ri documentation for hello_tvsze-0.0.0...
Installing RDoc documentation for hello_tvsze-0.0.0...
```

Tényleg ilyen egyszerű a kód megosztása Rubyval és RubyGemsel.

##TÖBB FÁJL HASZNÁLATA

Minden egy fájlba sűrítése nem túl jól skálázható. Adjunk még némi kódot ehhez a gemhez.

```ruby
% cat lib/hello_tvsze.rb
class Hello_tvsze
  def self.hi(language = "english")
    translator = Translator.new(language)
    translator.hi
  end
end

class Hello_tvsze::Translator
  def initialize(language)
    @language = language
  end

  def hi
    case @language
      when "hungarian"
        "Szia világ"
      else
        "hello world"
    end
  end
end
```

Most már azért nem olyan csupasz. Tegyük a **Translator**t egy külön fájlba. Mint már korábban említettem, a gem root fájlja felelős a gem kódjának a betöltéséért. A többi fájlt általában egy a gem nevével megegyező könyvtárban helyezkedik el ami a **lib** en belül van. Az alábbi módon:

```
% tree
.
├── hello_tvsze.gemspec
└── lib
    ├── hello_tvsze
    │   └── translator.rb
    └── hello_tvsze.rb
```
A **Translator** most már a **lib/hello_tvsze** ban van, ahonnan könnyen behívható egy **require** utasítással a **lib/hello_tvsze.rb** ból. A **Translator** kódja nem nagyon változott:

```ruby
% cat lib/hello_tvsze/translator.rb
# encoding: utf-8

class Translator
  def initialize(language)
    @language = language
  end

  def hi
    case @language
    when "hungarian"
      "Szia világ"
    else
      "hello world"
    end
  end
end
```
> Ne feledkezz meg a szöveg kódolást is beállítani a translator.rb fájban, ha használtál bármilyen különleges karaktert ( mint én most az á –t). UTF-8 általában egy jó választás.

Most már a **hello_tvsze.rb** kell némi kód ami betölti a **Translator** -t:

```ruby
% cat lib/hello_tvsze.rb
class Hello_tvsze
  def self.hi(language = "english")
    translator = Translator.new(language)
    translator.hi
  end
end

require 'hello_tvsze/translator'
```
> Emlékeztető: Újonnan létehozott fájlokat ne felejtsd el hello_tvsze.gemspec fájlba is bele tenni, így:
 
```ruby
% cat hello_tvsze.gemspec
Gem::Specification.new do |s|
...
s.files       = ["lib/hello_tvsze.rb", "lib/hello_tvsze/translator.rb"]
...
end
```
> A fenti módosítás nélkül a telepített gem nem tartalmazná az új könyvtárat.

Próbáljuk ki. Először indítsuk az **irb** -t:

```
% irb -Ilib -rhello_tvsze
irb(main):001:0> Hello_tvsze.hi("english")
=> "hello world"
irb(main):002:0> Hello_tvsze.hi("hungarian")
=> "Szia vil\u00E1g"
```
Egy furcsa parancssori flag et kell használni: **-Ilib**. Általában RubyGems hozzá adja a **lib** könyvtárat helyetted, így a végfelhasználóknak nem kell foglalkozniuk a betöltési út konfigurálásval. Ennek ellenére, amennyibe a kódot a RubyGemen kívül futtatod, akkor lehetséges a **$LOAD_PATH** ot manipulálni a kódon belülről, de a legtöbb esetben ezt anti-patternnek tartják. Rengeteg sok más anti-pattern van ( és good pattern !), amikről jobb képet [itt](http://guides.rubygems.org/patterns) kaphatsz.

Amennyiben mást fájlokat is hozzá adtál a gemedhez, akkor ne feledkezz meg azokat hozzáadni a gemspeced **files** tömbjébe mielőtt publikálod a gemedet. Többek között e miatt sok fejlesztő automatizálja ezt az alábbiak valamelyikével [Hoe](https://github.com/seattlerb/hoe), [Jeweler](https://github.com/technicalpickles/jeweler), [Rake](https://github.com/jimweirich/rake), [Bundler](http://railscasts.com/episodes/245-new-gem-with-bundler), vagy [just a dynamic gemspec](https://github.com/wycats/newgem-template/blob/master/newgem.gemspec).

További könyvtárak hozzáadása a már ismert procedúrát követi. Válaszd szét a Ruby fájljaidat, amikor annak értelme van! Értelmes struktúra létrehozása segítheti sok jövőbeli fejfájás elkerülését, mind a te számodra és gemed esetleges más fenntartói számára.

##FUTTATHATÓ FÁJL CSATOLÁSA

Ruby kód könyvtáron kívül a gemek egy vagy több futtatható fájlt is elérhetővé tehetnek a shelled **PATH** jához. Talán erre a legismertebb példa a **rake**. Egy másik nagyon hasznos a **prettify_json.rb**, ami [JSON](http://rubygems.org/gems/json) gemben van, ami JSON-t formáz olvasható formáttumban (az 1.9 Ruby ezt tartalmazza).

Futtatható fájl csatolása elég egyszerű. A fájlt csak a gemed **bin** könyvtárába kell tenni, majd a futtatható fájlok tömbjébe tenni a gemspec fájlban. Adjunk egyet hozzá a Hello_tvsze gemhez. Először hozzuk létre a fájt és tegyük futtathatóvá:

```
% mkdir bin
% copy nul > bin\hello_tvsze
```

A futtatható fájlnak csak egy [shebang](http://www.catb.org/jargon/html/S/shebang.html) kell , hogy tudja mivel kell futtatni. Így néz ki a Hello_tvsze futtatható fájlja.

```ruby
% cat bin/hello_tvsze
#!/usr/bin/env ruby

require 'hello_tvsze'
puts Hello_tvsze.hi(ARGV[0])
```

Annyit tesz hogy betölti a gemet és a parancssori első argumentumot átadja mint a hello nyelve. Itt egy példa a futtatására:

```
% ruby -Ilib ./bin/hello_tvsze
hello world

% ruby -Ilib ./bin/hello_tvsze hungarian
Szia világ
```

Végül, ahhoz hogy a push kor a Hello_tvsze’s futtatható fájlja is ott legyen tegyük azt bele a gemspec be is.

```ruby
% cat hello_tvsze.gemspec
Gem::Specification.new do |s|
  s.name        = 'hello_tvsze'
  s.version     = '0.0.1'
  s.executables << 'hello_tvsze'
  s.date        = '2014-11-29'
  s.summary     = "Hello world gem!"
  s.description = "A simple hello world gem"
  s.authors     = ["Varga Tamas"]
  s.email       = 'varga.tamas.8@inf.u-szeged.hu'
  s.files       = ["lib/hello_tvsze.rb", "lib/hello_tvsze/translator.rb", "bin/hello_tvsze"]
  s.homepage    =
      'https://github.com/TVSZE/RubyProject'
  s.license       = 'MIT'
end
```
Told (push) fel a gemet, és máris publikáltad a saját parancssori utilityd!

```
$ gem build hello_tvsze.gemspec
 Successfully built RubyGem
 Name: hello_tvsze
 Version: 0.0.1
 File: hello_tvsze-0.0.1.gem

$ gem push hello_tvsze-0.0.1.gem
Pushing gem to https://rubygems.org...
Successfully registered gem: hello_tvsze (0.0.1)
```

További futtatható fájlokat is csatolhatsz a **bin** könyvtárba ha szükséged van rá, ehhez van egy **executables** tömb mező a gemspecben.

> Megjegyzés: Ne felejtsd el növelni a gemed verzió számát amikor új verziókat adsz ki. Verziókról bővebb információt itt találhatsz: [Patterns Guide](http://guides.rubygems.org/patterns/#semantic-versioning)

##TESZTEK íRÁSA

A gemed tesztelése nagyon fontos. Nem csak azért fontos hogy meggyőződj arról hogy a kódod működik, hanem azért mert segíthet másoknak arról meggyőződni hogy a gemed elvégzi a rá bízott feladatot. A Ruby fejlesztők amikor értékelnek egy gemet sokszor úgy tekintenek egy jó tesztprocedúrára (vagy annak hiányára) mint ha az a kód megbízhatóságnak bizonyítványa lenne.

A gemek támogatják a teszt fájlok csomagba csatolását, így a tesztek a letöltés után egyből futtathatók. [GemTesters](http://test.rubygems.org/) nevű közösség jött lére, ami azzal foglalkozik hogy dokumentája a tesztprocedúrákat attól függően hogy azokat milyen architektúrán vagy Ruby fordítón használják.
Röviden: *TESZTELD A GEMED!* Légy szíves!

**Test::Unit** a Ruby bépített tesztelő keretrendszere. [Rengeteg](http://www.mikeperham.com/2012/09/25/minitest-ruby-1-9s-test-framework/)  [útmutató](https://github.com/seattlerb/minitest/blob/master/README.txt) létezik a használatához. Sok más egyéb tesztelő keretrendszeri is létezik. [RSpec](http://rspec.info/) egy népszerű választás. A nap végén nem nagyon számít mit használsz, csak *TESZTELJ*!
 
Adjunk néhány tesztet a Hello_tvsze-hez. Néhány fájlt kell a gemünkhöz adni, mint a **Rakefile** és egy új könyvtár **test**:

```
% tree
.
├── Rakefile
├── bin
│   └── hello_tvsze
├── hello_tvsze.gemspec
├── lib
│   ├── hello_tvsze
│   │   └── translator.rb
│   └── hello_tvsze.rb
└── test
    └── test_hello_tvsze.rb
```
A **Rakefile** néhány egyszerű automatát ad a teszteléshekhez:

```ruby
% cat Rakefile
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test
```

Most már futtathatod a **rake test** vagy csak simán **rake** -et a teszteléshez. Hurrá! Itt egy elég alap teszt fájl a hello_tvsze -hez:

```ruby
% cat test/test_hello_tvsze.rb
# encoding: utf-8

require 'minitest'
require 'minitest/autorun'
require 'hello_tvsze'

class Hello_tvsze_Test < Minitest::Test
  def test_english_hello
    assert_equal "hello world",
                 Hello_tvsze.hi("english")
  end

  def test_any_hello
    assert_equal "hello world",
                 Hello_tvsze.hi("ruby")
  end

  def test_hungarian_hello
    assert_equal "Szia világ",
                 Hello_tvsze.hi("hungarian")
  end
end
```

> Ne feletkezz meg a szöveg kódolást beállítani ha használtál valamilyen speciális karaktert ( mint én itt most az á –t ).
 
Végül, a teszt futtatása:

```
% ruby -Ilib:test test/test_hello_tvsze.rb
(Run options: --seed 10649

 # Running:

 ...

 Finished in 0.003501s, 856.8980 runs/s, 856.8980 assertions/s.

 3 runs, 3 assertions, 0 failures, 0 errors, 0 skips
```
Zöld! OK, attól függ milyen a shelled színkészlete. További kiválló példákért a [GitHub](https://github.com/search?utf8=%E2%9C%93&q=stars%3A%3E100+forks%3A%3E10&type=Repositories&ref=advsearch&l=Ruby) –on keresgélj.

Most már hogy vannak tesztjeink, kó ötlet lehet megnövelni a gem verzió számát és újból kitolni (push) a rubygems.org –ra.

Itt a frissített hello_tvsze.gemspec

```ruby
$ cat hello_tvsze.gemspec
Gem::Specification.new do |s|
  s.name          = 'hello_tvsze'
  s.version       = '0.0.2'
  s.executables   << 'hello_tvsze'
  s.date          = '2014-12-03'
  s.summary       = "Hello world gem!"
  s.description   = "A simple hello world gem"
  s.authors       = ["Varga Tamas"]
  s.email         = 'varga.tamas.8@inf.u-szeged.hu'
  s.files         = ["Rakefile", "lib/hello_tvsze.rb", "lib/hello_tvsze/translator.rb", "bin/hello_tvsze"]
  s.require_paths = ["lib"]
  s.test_files    = ["test/test_hello_tvsze.rb"]
  s.homepage      =
      'https://github.com/TVSZE/RubyProject'
  s.license       = 'MIT'
end
```

```
% gem build hello_tvsze.gemspec
 Successfully built RubyGem
 Name: hello_tvsze
 Version: 0.0.2
 File: hello_tvsze-0.0.2.gem

% gem push hello_tvsze-0.0.2.gem
Pushing gem to https://rubygems.org...
Successfully registered gem: hello_tvsze (0.0.2)
```

***

##DOKUMENTÁLD A KÓDOD

Alapból a legtöbb gem az RDoc ot használja autómatikus dokumentáció generálására. Rengeteg [kiválló útmuta](http://docs.seattlerb.org/rdoc/RDoc/Markup.html) létezik ahhoz hogy hogyan készítsd elő a kódod az RDoc számára. Itt egy egyszerű példa:

```markup
# The main Hello_tvsze driver
class Hello_tvsze
  # Say hi to the world!
  #
  # Example:
  #   >> Hello_tvsze.hi("hungarian")
  #   => Szia világ
  #
  # Arguments:
  #   language: (String)

  def self.hi(language = "english")
    translator = Translator.new(language)
    puts translator.hi
  end
end
```
Egy másik kiválló választás a dokumentáció generálásához a [YARD](http://yardoc.org/), mivel amikor feltolsz (push) egy gemet, [RubyDoc.info](http://rubydoc.info/) autómatikusan generál YARDocs –ot a gemedből. YARD visszafele kompatibilis az RDoccal, és van hozzá egy [jó leírás](http://rubydoc.info/docs/yard/file/docs/GettingStarted.md) ami taglalja hogy miben különbözik és hogy hogy kell használni.

***

##ZÁRSZÓ

A RubyGem készítés alapjaival felfegyverezve reméljük, hogy neki vágsz saját gemek készítésének kalandjába.

***

##KÖSZÖNET

Ez az útmutató a [rubygems.org](http://guides.rubygems.org/make-your-own-gem/#writing-tests) egy adaptációja ami eredetileg a [Gem Sawyer, Modern Day Ruby Warrior](http://rubylearning.com/blog/2010/10/06/gem-sawyer-modern-day-ruby-warrior/) ből készült. Ennek a gemnek a kódja megtalálható [GitHub](https://github.com/TVSZE/RubyProject) -on.

