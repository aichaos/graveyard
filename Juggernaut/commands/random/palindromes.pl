#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !palindromes
#    .::   ::.     Description // Get a random palindrome!
# ..:;;. ' .;;:..        Usage // !palindromes
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub palindromes {
	my ($self,$client,$msg,$listener) = @_;

	# Our list of palindromes.
	# There's so many it would be best to make it a
	# scalar and then deal with it later.
	my $list = <<PALINDROMES;
A daffodil slid off Ada.
A Dan, a clan, a canal - Canada!
A nut for a jar of tuna.
A Santa at NASA.
A Santa deified at NASA.
A Santa dog lived as a devil god at NASA.
A Santa lived as a devil at NASA.
A Santa lives evil at NASA.
A Santa pets rats, as Pat taps a star step at NASA.
A Santa snaps pans at NASA.
A Santa snips pins at NASA.
A Santa spat taps at NASA.
A Santa spit taboo bat tips at NASA.
A Santa spits tips at NASA.
A Santa spots tops at NASA.
A Santa stops pots at NASA.
A Santa taps Pat at NASA.
A Santa's rats top Nat, as Satan pots tars at NASA.
A Toyota! Race fast, safe car. A Toyota.
A Toyota.
A Toyota's a Toyota.
A car, a man, a maraca.
A coup d'etat saved devastated Puoca.
A dog! A panic in a pagoda!
A dog, a pant, a panic in a Patna Pagoda.
A dog, a plan, a canal: pagoda!
A dum reb was I ere I saw Bermuda.
A man, a pain, a mania - Panama.
A man, a plan, a butt tub: anal Panama!
A man, a plan, a canal: Panama!
A man, a plan, a cat, a ham, a yak, a yam, a hat, a canal--Panama!
A man? A prisoner! A cage? Iron! Did Noriega care? No, sir -- Panama!
A medico: "Negro Jamaica? A CIA major genocide, Ma."
A new order began, a more Roman age bred Rowena.
A nut nosed itself; it stifles tides on tuna.
A pain - a blast - ah, that's Albania, Pa!
A pre-war dresser drawer, Pa!
A relic, Odin! I'm a mini, docile Ra!
A slut nixes sex in Tulsa.
A tin mug for a jar of gum, Nita.
A tip: save Eva's pita.
A war at Tarawa.
Able was I ere I saw Elba.
Age, irony, Noriega.
Ah, Aristides opposed it, sir, aha!
Ah, Satan sees Natasha.
Ah, Satan, dog-deifier! (Oh who reified God, Natasha?)
Ah, Satan, shall a devil deliver Hannah? Reviled lived Allah's Natasha!
Aim a Toyota tatami mat at a Toyota, Mia.
Al lets Della call Ed Stella.
Alan Alda stops racecar, spots ad: "Lana-L.A."
All erotic, I lose my lyme solicitor, Ella.
Amiable was I ere I saw Elba, Ima.
Ana, nab a banana.
Analytic Paget saw an inn in a waste-gap city, Lana.
And DNA and DNA and DNA ...
And E.T. saw waste DNA.
Animal loots foliated detail of stool lamina.
Anna: "Did Otto peep?" Otto: "Did Anna?"
Anna was mad, no kayak on dam saw Anna.
Anne, I stay a day at Sienna.
Anne, I vote more cars race Rome to Vienna.
Apple ho ! Help, Pa!
Arden saw I was Nedra.
Are poets a waste? Opera!
Are we not drawn onward, we few, drawn onward to new era?
Are we not drawn onwards, we Jews, drawn onward to new era?
Are we not, Rae, near to new era?
Ban campus motto, "Bottoms up, MacNab."
Bird rib.
Bob, level Bob.
Bob: "Did Anna peep?" Anna: "Did Bob?"
Bombard a drab mob.
Boston did not sob.
Boston, O do not sob.
Bush saw Sununu swash sub.
But sad Eva saved a stub.
Cain: A maniac!
Camus sees sumac.
Cigar? Too tragic!
Cigar? Toss it in a can, it is so tragic.
Cleveland DNA: Level C.
DNA-land.
Daedalus: nine, Peninsula: dead.
Dairy myriad.
Dammit, I'm mad!
Damn! I, Agassi, miss again! Mad!
Darn ocelots stole Conrad.
Dee saw a seed.
Deer flee freedom in Oregon? No, Geronimo - deer feel freed.
"Degenerate Moslem, a cad!" Eva saved a camel so Meta reneged.
Degenerative Tulsa slut (Evita) reneged.
Deified.
Deirdre wets altar of St. Simons - no mists, for at last ewer dried.
Dek's a sassy banana, my man - an abyss as asked!
Del saw a sled.
Delia and Edna ailed.
Delia failed.
Delia sailed as a sad Elias ailed.
Delia sailed, Eva waved, Elias ailed.
Delia saw I was ailed.
Delia, here we nine were hailed.
Deliver, Eva, him I have reviled.
"Deliver My Band's DNA," by Mr. Evil Ed.
Denim axes examined.
Dennis and Edna sinned.
Dennis sinned.
Dennis, no misfit can act if Simon sinned.
Deny me not; atone, my Ned.
Depardieu, go razz a rogue I draped.
Desserts I desire not, so long no lost one rise distressed.
Desserts, I stressed!
Detartrated.
Devil Natasha, ah, Satan lived !
Di, did I as I said I did?
Did Dean aid Diana? Ed did.
Did Hannah say as Hannah did?
Did Hannah see bees? Hannah did.
Did I dine, Enid? I did!
Didi won straw warts? Now I did!
Did I do, O God, did I as I said I'd do? Good, I did!
Did I draw Della too tall, Edward? I did!
Did I strap red nude, red rump, also slap murdered underparts? I did!
Did I, debating, Nita dating, Nita bed? I did.
Do Good's deeds live on? No, Evil's deeds do, O God.
Do geese see God?
Do good? I? No! Evil anon I deliver. I maim nine more hero-men in Saginaw, sanitary sword a-tuck, Carol, I--lo!--rack, cut a drowsy rat in Aswan. I gas nine more hero-men in Miami. Reviled, I (Nona) live on. I do, O God!
Do not start at rats to nod.
Do, O God, no evil deed, live on, do good.
Doc, note I dissent: a fast never prevents a fatness. I diet on cod.
Dog sex at noon taxes God.
Dog-deifiers reified God.
Dog embargo: O grab me, God!
Dog, as a devil deified, lived as a god.
Dog--no poop on God!
Dogma in my hymn: I am God!
Dogma: I am God.
"Do nine men interpret?" "Nine men," I nod.
Don't nod.
Doom an evil deed, liven a mood.
Dot saw I was Tod.
Dot sees Tod.
Dr. Awkward
Drab as a fool, aloof as a bard.
Drab bard.
Drat Sadat, a dastard!
Drat Saddam, a mad dastard!
Draw no dray a yard onward.
Draw pupil's lip upward.
Draw putrid dirt upward.
Draw, O Caesar, erase a coward. 
Draw, O coward!
Drawer's reward.
Drawn inward.
Drowsy baby's word.
Duo loved Devo loud.
Dumb mobs bomb mud.
Dumb mud.
E. Borgnine drags Dad's gardening robe.
Ed is on no side.
Ed, I saw Harpo Marx ram Oprah W. aside.
Ed: a general, a renegade.
Egad! A base tone denotes a bad age
Egad! Loretta has Adams mad as a hatter. Old age!
Egad! No bondage!
Egad, a base life defiles a bad age.
Egad, an adage!
Elf farm raffle.
Elk cackle.
Embargos are macabre. Sad Nell, listen O! not to no nets--I'll lend a Serb a camera so grab me!
Emil asleep, Hannah peels a lime.
Emil saw a slime.
Emil, a sleepy baby peels a lime.
Emit Eno one time.
Emit a mile, lima time.
Emit no tot on time.
Enola Devil lived alone.
Er, go on, trap Steven in, I say. Me oh my! Nor can an "air" bee sew. We see, Brian. An acronym? Hoe my asinine vet's part? No, ogre!
Ergo -- ogre!
Eros' sis is sore
Eros? Sidney, my end is sore!
Et tu, Butte?
Euston saw I was not Sue.
Eva can ignite virtuosos out riveting in a cave.
Eva, can I pose as Aesop in a cave?
Eva, can I stab bats in a cave?
Evade me, Dave.
Eve damned Eden, mad Eve.
Eve saw diamond, erred, no maid was Eve.
Evil I did dwell, lewd did I live.
Evil is a name of a foeman, as I live.
Evil olive.
Evil Tim must at summit live.
Feeble Tom's motel beef.
Flee to me, remote elf.
Fleece elf.
Flesh! Saw I Mimi wash self!
Flo, gin is a sin. I golf.
Gateman sees name, garageman sees name tag.
Gel on no leg.
Gert, I saw Ron avoid a radio-van - or was it Reg?
Gift fig.
Gnu dung.
Gnu hung.
Go deliver a dare, vile dog.
Go hang a salami, I'm a lasagna hog.
Go! Desire vagina! Man I gave. Rise, dog.
Go, dog!
God damn! Mad dog.
God lived as a devil dog
God lived on no devil dog.
God saw I was dog.
God to Hanoi on a hot dog
God! A red nugget! A fat egg under a dog!
God! Nate bit a Tibetan dog!
God, Edam made dog.
God, a saw was a dog!
God, a slap! Paris, sir, appals a dog.
God: Deified dog.
Goddam mad dog!
Goldenrod-adorned log.
Golf? No sir, prefer prison-flog.
Greta? Education? No, it a cud eater, G.
Gustav Klimt milk vats - ug!
Haiti--ah!
Harass Sarah!
Harass selfless Sarah!
Harass sensuousness, Sarah.
Harder, Albion, On! O, I blared, Rah!
He did, eh?
He goddam mad dog, eh? 
He harasses Sarah, eh?
He lived as a devil, eh?
He maps spam, eh?
He stops spots, eh?
He won a Toyota now, eh?
He won snow, eh?
He won't, ah, wander, Edna. What now, eh?
Here so long? No loser, eh?
I did not revert on Didi.
I did, did I?
"I Love Me, Vol. I."
I maim Miami.
I met System I.
I moan, "Live on, O evil Naomi!"
I prefer pi.
I roamed under it as a tired, nude Maori.
I saw I was I.
I saw desserts; I'd no lemons, alas no melon. Distressed was I.
I saw thee, madame, eh? 'Twas I.
I won, Karen, an era know I.
I'm, alas, a salami!
I, Marian, I too fall; a foot-in-air am I.
I, Mary, tramp martyr. Am I?
I, Rasputin, knit up Sari.
I, madam, I, made radio -- so I dared! Am I mad? Am I?
I, man, am regal; a German am I.
I, zani Nazi.
If I had a hi-fi.
In Oz, no Ronzoni.
In a regal age ran I.
Is Don Adams mad? (A nod.) Si!
Jar a tonga, nag not a raj.
KC, answer DNA loop award. Emit time. Draw a Pool. Andrew, snack.
Kay, a red nude, peeped under a yak.
Kay, a red nude, pooped under a yak.
Kayak salad - Alaska yak.
Kayak.
Koala, Al? A-OK!
Lager, Sir, is regal.
Lager, never even regal.
Laid on no dial.
Laminated E.T. animal.
Lana C. LaDaug was I ere I saw Guadalcanal.
Lay a wallaby baby ball away, Al.
Lee had a heel.
Lem saw I was Mel.
Lepers repel.
Let O'Hara gain an inn in a Niagara hotel.
Levo, hang a salsa romano on Amora's lasagna hovel.
Lew, Otto has a hot towel!
Lewd I did live, evil did I dwel.
Lid of fade, metallic soot, emit Garret-simple, help Mister Ragtime to oscillate me, daffodil.
Lid off a daffodil.
Lion oil.
Lisa Bonet ate no basil.
Live dirt up a side track carted is a putrid evil.
Live evil.
Live! For at last, Seth tests altar of evil!
Live not on evil, madam, live not on evil.
Live on evasions? No, I save no evil.
Live, O Devil, revel ever, live, do evil.
Lived on Decaf, faced no Devil.
Lon Nol.
Lonely Tylenol.
"M" lab menial slain: embalm.
Ma has a ham.
Ma is a nun, as I am.
Ma is as selfless as I am.
Mad Zeus, no live devil, lived evil on Suez dam.
Mad am I, madam!
Mad dastard, a sad rat - Saddam.
Madam in Eden, I'm Adam.
Madam, I'm Adam.
Madam, I mad am.
Malayalam.
Man, Eve let an irate tar in at eleven a.m.
Man, Oprah's sharp on AM.
Marge lets Norah see Sharon's telegram.
May a banana nab a yam.
May a moody baby doom a yam?
Mayhem, eh Yam?
Megawatt Ottawa gem.
Men, I'm Eminem.
Mike's ol' llama'll lose Kim.
Mix a maxim.
"Miry rim! So many daffodils," Delia wailed, "slid off a dynamo's miry rim!"
Mr. Owl ate my metal worm.
Mr. Owl is a basil worm.
Murder for a jar of red rum.
Must sell at tallest sum.
My g-spot stops gym.
N.A. medico: "Negro Jamaica? A CIA major genocide, man."
Nam was a saw man
Name no one man.
Named undenominationally rebel, I rile Beryl. La, no! I tan. I'm, O Ned, nude man!
Naomi, did I moan?
"Naomi, sex at noon taxes!" I moan.
"Naomi," I moan.
Nate bit a Tibetan
Ned, I am a maiden.
Ned, go gag Ogden.
Neil A. sees alien!
Never odd or even.
Niagara, O roar again.
No cab, no tuna nut on bacon.
No cabs' bulbs? A gnat's tool loots Tan "Gas" Blub's bacon.
No devil lived on.
No evil shahs live on.
No evil I did I live on.
No garden, one dragon.
No lad egged Al on.
No lemon DNA and no melon.
No lemons, no melon.
No miss, it is Simon.
No misses ordered roses, Simon
No -- noose be soon on!
No side, no in union, Edison.
No sir! Away! A papaya war is on.
No stetson hats. Operas are post. Ah, no stetson.
No witness--a fool. A nasal aria's time emits air. Alas, an aloof assent: I won.
No, I met System Ion.
No, Mel Gibson is a casino's big lemon.
No, Mel, a sleepy baby peels a lemon.
No, Sir, prefer prison.
No, Sir. Panic is a basic in a prison.
No, it is open on one position.
No, it is opposition.
No, it never propagates if I set a GAP or PREVENTION.
No, she stops spots, eh, son?
No "x" in Nixon?
Noel, let's egg Estelle on.
Nog eroded Oregon.
Nor I nor Emma had level'd a hammer on iron.
Nora, a raft! Is it far, Aaron?
Nora, alert, saws goldenrod adorned logs, wastrel aaron.
Norah's moods, alas, doom Sharon.
Noriega can idle, held in a cage ... Iron!
Norma is as selfless as I am, Ron.
Nosegay ages on.
Nosh, oh son!
Not New York, Roy went on.
Not lads simple, help Miss Dalton.
Not so, Boston!
Now's evil for evil? Ah, a liver of lives won!
Now, Ned, I am a maiden nun; Ned, I am a maiden won.
Nurse, I spy gypsies, run!
O cat, a dada taco!
O, had I nine to ten in Idaho!
O tarts! A castrato!
O, Geronimo -- no minor ego!
O, I hope Ed 'n' I see referees in deep Ohio.
O, memsahib Bart, rabbi has memo.
O, stone, be not so.
O.E.D. or rodeo?
Oh, cameras are macho.
Oh, no! Don Ho!
Olson is in Oslo.
On a clover, if alive, erupts a vast, pure evil; a fire volcano.
Otto did Bob did Otto
Otto, Em, and I did name Otto.
Otto saw pup; pup was Otto.
Pa's a sap.
Paganini: din in a gap.
Paget saw an Irish tooth, Sir, in a waste gap.
Pam evals a slave map.
Parcel bare ferret up mock computer-referable crap.
Party boobytrap.
Party-trap.
"Peanuts' Legs" is Gels' Tuna EP.
Pint a' catnip.
Plan no damn Madonna LP.
Poor Dan is in a droop.
Poor Das is a droop.
Puff in, sniff up!
Pull up if I pull up.
Pus, Dan! Ogre sales use laser gonads up.
Put a crow, a camel, a mini male macaw, or cat up.
Qadi called Della C "Ida Q."
"Q": a F.A.Q.
Racecar.
Race carrot or race car?
Radar.
Rae! Bite yon no yeti bear!
Rat-star.
Rats ailed, damn it, in mad Delia's tar!
Rats drown in WordStar
Rats live on no evil star.
Raw sexes war.
Raw, evil dam on Niagara. Gain net time! Sub bus, emit ten Niagara! Gain no mad, live war!
Re-paper.
Red Nevada vender.
Red lost case, Ma. Jesse James acts older.
Red rum is Pepsi murder.
Red rum, sir, is murder.
"Red?" "No." "Who is it?" "'Tis I." "Oh, wonder!"
Redivider.
Redraw a warder.
Reflog a golfer
Regal lager.
Reign at Tangier.
Remarkable was I ere I saw Elba Kramer.
Reno loner.
Reviled did I live, said I, as evil I did deliver.
Reviled, I wonder if I fired. Now, I deliver!
Reviver.
Rise to vote, sir.
Rise, Sir Lapdog! Revolt, lover! God, pal, rise, sir!
Rise, take lame female Kate, sir.
Rob a loneliness? Senile, no labor.
Rococo "R".
Rot can rob a born actor.
Rot-corpse Sumatran art amuses proctor.
Rub bur.
Sad, I'm Midas.
Satan, oscillate my metallic sonatas!
Saw tide rose? So red it was.
Senile felines.
Set at serif, as Safire states.
Sex rex? Nil, ever - I revel in Xerxes!
Sex at noon taxes.
Sex-aware era waxes.
Sex elf flexes.
Sh! Tom sees moths.
Sir, I soon saw Bob was no Osiris.
Sis, Sargasso moss a grass is.
Sis, ask Costner to not rent socks "as is"!
Sit on a potato pan, Otis.
Slap a ham on Omaha, pals.
Smart ewes use wet rams.
Snug & raw was I ere I saw war & guns.
Snug all L.A. guns!
So many dynamos.
So, G. Rivera's tots are virgos.
So, Ida, adios!
So, camera solos are MacOS?
Solo gigolos.
Solos.
Some men interpret nine memos.
Sore eye, Eros?
Sore was I ere I saw Eros.
Stab nail at ill Italian bats.
Star Wars awe was raw rats.
Star comedy by Democrats.
Star-red rum and Edna murder rats.
Star? Come Donna Melba, I'm an amiable man, no Democrats!
Stella won no wallets.
Step on no pets.
Stiff, O Dairyman, in a myriad of fits.
Stop! Murder us not, tonsured rumpots!
Stratagem: megatarts.
Straw warts.
Straw? No, too stupid a fad; I put soot on warts.
Stressed? No tips? Spit on desserts!
Stunts is. Niece insist nuts.
Sums are not set as a test on Erasmus.
Sun at noon, tan us.
Suneva, Nina is sure Russian in a Venus.
Sup not on pus.
Suppository rot; I sop pus.
Swap God for a janitor? Rot in a jar of dog paws!
Swen, on gnus, sung no news.
Sycamore has a hero: Macy's.
T. Eliot nixes sex in toilet!
T. Eliot, top bard, notes putrid tang emanating, is sad. I'd assign it a name: gnat dirt upset on drab pot-toilet.
Taco cat.
Tango gnat.
Tarzan raised Desi Arnaz' rat.
Tarzan raised a Desi Arnaz rat.
Ten animals I slam in a net.
Tense, I snap Sharon roses, or Norah's pansies net.
'Til lips spill it.
Tin sanitary rat in a snit.
Tips spill, lips spit.
'Tis in a DeSoto sedan I sit
To Idi Amin: I'm a idiot!
To: Dr., et al. / Re: Grub / Ma had a hamburger / Later, Dot.
Todd erases a red dot.
Toni Tennille fell in net. I, not!
Too bad, I hid a boot.
Too far, Edna, we wander afoot.
Too hot to hoot
Topekans' niece in snake pot!
Top spot.
Top step's pup's pet spot.
Trays simple help, missy art!
Tulsa night life: filth, gin, a slut.
Tuna nut.
U.F.O. tofu.
Unremarkable was I ere I saw Elba Kramer, nu?
Vanna, wanna V?
Vote to not slip up, refer pupils to note TOV.
War, sir, is raw.
Warsaw was raw.
Was in a myriad a dairyman I saw.
Was it Eliot's toilet I saw?
Was it a bar or a bat I saw?
Was it a bat I saw?
Was it a car or a cat I saw?
Was it a cat I saw?
Was it a rat I saw?
Was raw tap ale not a reviver at one lap at Warsaw?
We few erase cares, Al; laser aces are we few.
We few.
We panic in a pew.
We seven, Eve, sew.
Wo Nemo! Toss a lasso to me now!
Woman maps yam snot and DNA--tons may spam Nam. Ow!
Won't lovers revolt now?
Wonder if Sununu's fired now.
Wonton? Not now.
Wontons? Not now.
Xerxes was stunned! Eden nuts saw sex, rex!
Yale mate made dame tame lay.
Yawn a more Roman way!
Yawn--Madonna fan? No damn way!
Yell upset a cider: predicates pulley.
Yes, Mary Ramsey.
Yo Bob, mug a gumbo boy!
Yo! Banana Boy!
Yo! job mug gumbo joy!
Yo, Bottoms up! (U.S. motto, boy.)
Yo, oy.
Yoba saw I was a boy.
Young Ada had a gnu. Oy!
Yreka Bakery
Zoo to tote Toto to Oz.
Zeus was deified, saw Suez.
PALINDROMES

	# Turn the list of palindromes into an array.
	my @palindromes = split(/\n/, $list);

	# Count the palindromes.
	print "Number of Palindromes: " . scalar(@palindromes) . "\n";

	# Get a random palindrome.
	my $reply = $palindromes [ int(rand(scalar(@palindromes))) ];

	# Return the reply.
	return $reply;
}

{
	Category => 'Random Stuff',
	Description => 'Random Palindromes',
	Usage => '!palindromes',
	Listener => 'All',
};