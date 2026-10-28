/// Source-based directory, separate from unreviewed legacy tracing packs.
/// Names/types are checked against the Survey of India 2026 political map.
class ExplorerPlace {
  const ExplorerPlace(this.name, this.hindi, this.type, this.fact);
  final String name, hindi, type, fact;
}

const explorerPlaces = [
  ExplorerPlace(
    'Andhra Pradesh',
    'आंध्र प्रदेश',
    'State',
    'Andhra Pradesh is beside the Bay of Bengal.',
  ),
  ExplorerPlace(
    'Arunachal Pradesh',
    'अरुणाचल प्रदेश',
    'State',
    'Arunachal Pradesh is in northeastern India.',
  ),
  ExplorerPlace(
    'Assam',
    'असम',
    'State',
    'The Brahmaputra River flows through Assam.',
  ),
  ExplorerPlace(
    'Bihar',
    'बिहार',
    'State',
    'The Ganga River flows through Bihar.',
  ),
  ExplorerPlace(
    'Chhattisgarh',
    'छत्तीसगढ़',
    'State',
    'Chhattisgarh is in central India.',
  ),
  ExplorerPlace('Goa', 'गोवा', 'State', 'Goa is beside the Arabian Sea.'),
  ExplorerPlace('Gujarat', 'गुजरात', 'State', 'Gujarat is in western India.'),
  ExplorerPlace('Haryana', 'हरियाणा', 'State', 'Haryana is next to Delhi.'),
  ExplorerPlace(
    'Himachal Pradesh',
    'हिमाचल प्रदेश',
    'State',
    'Himachal Pradesh is in the Himalayan region.',
  ),
  ExplorerPlace('Jharkhand', 'झारखंड', 'State', 'Jharkhand is next to Bihar.'),
  ExplorerPlace(
    'Karnataka',
    'कर्नाटक',
    'State',
    'Karnataka is in southern India.',
  ),
  ExplorerPlace('Kerala', 'केरल', 'State', 'Kerala is beside the Arabian Sea.'),
  ExplorerPlace(
    'Madhya Pradesh',
    'मध्य प्रदेश',
    'State',
    'Madhya Pradesh is in central India.',
  ),
  ExplorerPlace(
    'Maharashtra',
    'महाराष्ट्र',
    'State',
    'Maharashtra is beside the Arabian Sea.',
  ),
  ExplorerPlace(
    'Manipur',
    'मणिपुर',
    'State',
    'Manipur is in northeastern India.',
  ),
  ExplorerPlace('Meghalaya', 'मेघालय', 'State', 'Meghalaya is next to Assam.'),
  ExplorerPlace(
    'Mizoram',
    'मिज़ोरम',
    'State',
    'Mizoram is in northeastern India.',
  ),
  ExplorerPlace(
    'Nagaland',
    'नागालैंड',
    'State',
    'Nagaland is in northeastern India.',
  ),
  ExplorerPlace(
    'Odisha',
    'ओडिशा',
    'State',
    'Odisha is beside the Bay of Bengal.',
  ),
  ExplorerPlace('Punjab', 'पंजाब', 'State', 'Punjab is in northwestern India.'),
  ExplorerPlace(
    'Rajasthan',
    'राजस्थान',
    'State',
    'Rajasthan is in western India.',
  ),
  ExplorerPlace(
    'Sikkim',
    'सिक्किम',
    'State',
    'Sikkim is in the Himalayan region.',
  ),
  ExplorerPlace(
    'Tamil Nadu',
    'तमिलनाडु',
    'State',
    'Tamil Nadu is in southern India.',
  ),
  ExplorerPlace(
    'Telangana',
    'तेलंगाना',
    'State',
    'Telangana is next to Andhra Pradesh.',
  ),
  ExplorerPlace(
    'Tripura',
    'त्रिपुरा',
    'State',
    'Tripura is in northeastern India.',
  ),
  ExplorerPlace(
    'Uttar Pradesh',
    'उत्तर प्रदेश',
    'State',
    'The Taj Mahal is in Agra, Uttar Pradesh.',
  ),
  ExplorerPlace(
    'Uttarakhand',
    'उत्तराखंड',
    'State',
    'Uttarakhand is in the Himalayan region.',
  ),
  ExplorerPlace(
    'West Bengal',
    'पश्चिम बंगाल',
    'State',
    'West Bengal is beside the Bay of Bengal.',
  ),
  ExplorerPlace(
    'Andaman and Nicobar Islands',
    'अंडमान और निकोबार द्वीपसमूह',
    'Union territory',
    'These islands are in the Bay of Bengal.',
  ),
  ExplorerPlace(
    'Chandigarh',
    'चंडीगढ़',
    'Union territory',
    'Chandigarh is a union territory in northern India.',
  ),
  ExplorerPlace(
    'Dadra and Nagar Haveli and Daman and Diu',
    'दादरा और नगर हवेली और दमन और दीव',
    'Union territory',
    'This union territory has separate parts in western India.',
  ),
  ExplorerPlace(
    'Delhi',
    'दिल्ली',
    'Union territory',
    'New Delhi is the capital of India.',
  ),
  ExplorerPlace(
    'Jammu and Kashmir',
    'जम्मू और कश्मीर',
    'Union territory',
    'Jammu and Kashmir is in northern India.',
  ),
  ExplorerPlace(
    'Ladakh',
    'लद्दाख',
    'Union territory',
    'Ladakh is in northern India.',
  ),
  ExplorerPlace(
    'Lakshadweep',
    'लक्षद्वीप',
    'Union territory',
    'These islands are in the Arabian Sea.',
  ),
  ExplorerPlace(
    'Puducherry',
    'पुदुच्चेरी',
    'Union territory',
    'Puducherry has separate parts in southern India.',
  ),
];

const explorerNeighbours = [
  ExplorerPlace(
    'Bangladesh',
    'बांग्लादेश',
    'Land neighbour',
    'Bangladesh is to the east of India.',
  ),
  ExplorerPlace(
    'Bhutan',
    'भूटान',
    'Land neighbour',
    'Bhutan is a Himalayan neighbour of India.',
  ),
  ExplorerPlace(
    'China',
    'चीन',
    'Land neighbour',
    'China is a neighbour to the north of India.',
  ),
  ExplorerPlace(
    'Myanmar',
    'म्यांमार',
    'Land neighbour',
    'Myanmar is to the east of India.',
  ),
  ExplorerPlace(
    'Nepal',
    'नेपाल',
    'Land neighbour',
    'Nepal is a Himalayan neighbour of India.',
  ),
  ExplorerPlace(
    'Pakistan',
    'पाकिस्तान',
    'Land neighbour',
    'Pakistan is to the west of India.',
  ),
  ExplorerPlace(
    'Afghanistan',
    'अफ़ग़ानिस्तान',
    'Land neighbour',
    'Afghanistan is included in India’s official land-border description.',
  ),
  ExplorerPlace(
    'Sri Lanka',
    'श्रीलंका',
    'Nearby island country',
    'Sri Lanka is across the sea, south of India.',
  ),
  ExplorerPlace(
    'Maldives',
    'मालदीव',
    'Nearby island country',
    'The Maldives is an island country southwest of India.',
  ),
];

class HindiPictureWord {
  const HindiPictureWord(this.word, this.meaning, this.picture);
  final String word, meaning, picture;
}

const hindiVowels = ['अ', 'आ', 'इ', 'ई', 'उ', 'ऊ', 'ऋ', 'ए', 'ऐ', 'ओ', 'औ'];
const hindiConsonants = [
  'क',
  'ख',
  'ग',
  'घ',
  'ङ',
  'च',
  'छ',
  'ज',
  'झ',
  'ञ',
  'ट',
  'ठ',
  'ड',
  'ढ',
  'ण',
  'त',
  'थ',
  'द',
  'ध',
  'न',
  'प',
  'फ',
  'ब',
  'भ',
  'म',
  'य',
  'र',
  'ल',
  'व',
  'श',
  'ष',
  'स',
  'ह',
];
/// Words a child can make from a letter. Spoken with device speech.
const hindiLetterWords = <String, List<HindiPictureWord>>{
  'अ': [HindiPictureWord('अनार', 'Pomegranate', 'pomegranate')],
  'आ': [HindiPictureWord('आम', 'Mango', 'mango')],
  'क': [HindiPictureWord('कमल', 'Lotus', 'lotus'), HindiPictureWord('केला', 'Banana', 'banana'), HindiPictureWord('किताब', 'Book', 'book')],
  'ग': [HindiPictureWord('घर', 'House', 'house'), HindiPictureWord('गेंद', 'Ball', 'ball')],
  'प': [HindiPictureWord('पेड़', 'Tree', 'tree')],
  'फ': [HindiPictureWord('फूल', 'Flower', 'flower')],
  'म': [HindiPictureWord('मछली', 'Fish', 'fish')],
  'स': [HindiPictureWord('सेब', 'Apple', 'apple'), HindiPictureWord('सूरज', 'Sun', 'sun')],
};

const hindiPictureWords = [
  HindiPictureWord('अनार', 'Pomegranate', 'pomegranate'),
  HindiPictureWord('आम', 'Mango', 'mango'),
  HindiPictureWord('कमल', 'Lotus', 'lotus'),
  HindiPictureWord('केला', 'Banana', 'banana'),
  HindiPictureWord('सेब', 'Apple', 'apple'),
  HindiPictureWord('फूल', 'Flower', 'flower'),
  HindiPictureWord('घर', 'House', 'house'),
  HindiPictureWord('पेड़', 'Tree', 'tree'),
  HindiPictureWord('मछली', 'Fish', 'fish'),
  HindiPictureWord('सूरज', 'Sun', 'sun'),
  HindiPictureWord('गेंद', 'Ball', 'ball'),
  HindiPictureWord('किताब', 'Book', 'book'),
];

class ExplorerItem {
  const ExplorerItem({
    required this.title,
    required this.detail,
    required this.choices,
    this.hindi = false,
    this.picture,
  });
  final String title, detail;
  final List<String> choices;
  final bool hindi;
  final String? picture;
}

const explorerMonuments = <String, ExplorerItem>{
  'qutb-minar': ExplorerItem(
    title: 'Qutb Minar',
    detail: 'Delhi. A tall sandstone tower with carved bands.',
    choices: ['Qutb Minar', 'Taj Mahal'],
    picture: 'qutb-minar',
  ),
  'red-fort': ExplorerItem(
    title: 'Red Fort',
    detail: 'Delhi. Look at its red sandstone walls and gates.',
    choices: ['Red Fort', 'Shore Temple'],
    picture: 'red-fort',
  ),
  'taj-mahal': ExplorerItem(
    title: 'Taj Mahal',
    detail:
        'Agra, Uttar Pradesh. A white marble monument beside the Yamuna River.',
    choices: ['Taj Mahal', 'Sanchi Stupa'],
    picture: 'taj-mahal',
  ),
  'sanchi': ExplorerItem(
    title: 'Sanchi Stupa',
    detail: 'Sanchi, Madhya Pradesh. Look at the round stupa and its carved gateways.',
    choices: ['Sanchi Stupa', 'Taj Mahal'],
    picture: 'sanchi',
  ),
  'konark': ExplorerItem(
    title: 'Konark Sun Temple',
    detail: 'Konark, Odisha. The temple has stone carvings shaped like chariot wheels.',
    choices: ['Konark Sun Temple', 'Shore Temple'],
    picture: 'konark',
  ),
  'shore-temple': ExplorerItem(
    title: 'Shore Temple',
    detail:
        'Mahabalipuram, Tamil Nadu. These stone temples stand beside the sea.',
    choices: ['Shore Temple', 'Sanchi Stupa'],
    picture: 'shore-temple',
  ),
};

ExplorerItem? explorerItemById(String id) {
  final parts = id.split(':');
  if (parts.length != 3) return null;
  if (parts[0] == 'hi' && (parts[1] == 'vowel' || parts[1] == 'consonant')) {
    final letters = parts[1] == 'vowel' ? hindiVowels : hindiConsonants;
    final index = letters.indexOf(parts[2]);
    if (index < 0) return null;
    return ExplorerItem(
      title: letters[index],
      detail: 'Listen, then find the same letter.',
      choices: [letters[index], letters[(index + 1) % letters.length]],
      hindi: true,
    );
  }
  if (parts[0] == 'hi' && parts[1] == 'family') {
    final letter = parts[2];
    final words = hindiLetterWords[letter];
    if (words == null || words.isEmpty) {
      return null;
    }
    final word = words.first;
    return ExplorerItem(
      title: word.word,
      detail: 'The letter $letter can begin ${words.map((item) => '${item.word} (${item.meaning})').join(', ')}.',
      choices: [word.word, word.meaning],
      hindi: true,
      picture: word.picture,
    );
  }
  if (parts[0] == 'hi' && parts[1] == 'word') {
    for (var index = 0; index < hindiPictureWords.length; index++) {
      final word = hindiPictureWords[index];
      if (word.picture == parts[2]) {
        return ExplorerItem(
          title: word.word,
          detail: word.meaning,
          choices: [
            word.word,
            hindiPictureWords[(index + 1) % hindiPictureWords.length].word,
          ],
          hindi: true,
          picture: word.picture,
        );
      }
    }
  }
  if (parts[0] == 'india' &&
      (parts[1] == 'region' || parts[1] == 'neighbour')) {
    final places = parts[1] == 'region' ? explorerPlaces : explorerNeighbours;
    final index = int.tryParse(parts[2]);
    if (index == null ||
        index < 0 ||
        index >= places.length ||
        '$index' != parts[2]) {
      return null;
    }
    final place = places[index];
    return ExplorerItem(
      title: place.name,
      detail: '${place.hindi}\n${place.type}\n\n${place.fact}',
      choices: [place.name, places[(index + 1) % places.length].name],
    );
  }
  if (parts[0] == 'india' && parts[1] == 'monument') {
    return explorerMonuments[parts[2]];
  }
  return null;
}
