import 'explorer_content.dart';
import '../models/age_band.dart';

/// Main capital names; special conventions are explained rather than hidden.
const indiaCapitals = <String, String>{
  'Andhra Pradesh': 'Amaravati',
  'Arunachal Pradesh': 'Itanagar',
  'Assam': 'Dispur',
  'Bihar': 'Patna',
  'Chhattisgarh': 'Raipur',
  'Goa': 'Panaji',
  'Gujarat': 'Gandhinagar',
  'Haryana': 'Chandigarh',
  'Himachal Pradesh': 'Shimla',
  'Jharkhand': 'Ranchi',
  'Karnataka': 'Bengaluru',
  'Kerala': 'Thiruvananthapuram',
  'Madhya Pradesh': 'Bhopal',
  'Maharashtra': 'Mumbai',
  'Manipur': 'Imphal',
  'Meghalaya': 'Shillong',
  'Mizoram': 'Aizawl',
  'Nagaland': 'Kohima',
  'Odisha': 'Bhubaneswar',
  'Punjab': 'Chandigarh',
  'Rajasthan': 'Jaipur',
  'Sikkim': 'Gangtok',
  'Tamil Nadu': 'Chennai',
  'Telangana': 'Hyderabad',
  'Tripura': 'Agartala',
  'Uttar Pradesh': 'Lucknow',
  'Uttarakhand': 'Dehradun',
  'West Bengal': 'Kolkata',
  'Andaman and Nicobar Islands': 'Sri Vijaya Puram',
  'Chandigarh': 'Chandigarh',
  'Dadra and Nagar Haveli and Daman and Diu': 'Daman',
  'Delhi': 'New Delhi',
  'Jammu and Kashmir': 'Srinagar and Jammu',
  'Ladakh': 'Leh',
  'Lakshadweep': 'Kavaratti',
  'Puducherry': 'Puducherry',
};
const capitalNotes = <String, String>{
  'Himachal Pradesh':
      'Shimla is the capital. Dharamshala is the second capital.',
  'Maharashtra': 'Mumbai is the main capital. Nagpur is the winter capital and hosts the winter legislative session.',
  'Uttarakhand':
      'Dehradun is the provisional capital. Gairsain is the summer capital.',
  'Jammu and Kashmir':
      'Srinagar is the summer capital. Jammu is the winter capital.',
  'Ladakh': 'Leh is the capital city in the official gazette. Kargil is also an important administrative centre; some government services describe joint capitals.',
  'Punjab': 'Chandigarh is shared as the capital of Punjab and Haryana.',
  'Haryana': 'Chandigarh is shared as the capital of Haryana and Punjab.',
  'Andaman and Nicobar Islands':
      'Sri Vijaya Puram was formerly called Port Blair.',
};

enum IndiaQuestionKind { locate, capital, neighbour, monument, mapBasics }

class IndiaQuestion {
  const IndiaQuestion({
    required this.id,
    required this.kind,
    required this.prompt,
    required this.answer,
    required this.teaching,
    this.options = const [],
    this.picture,
  });
  final String id, prompt, answer, teaching;
  final IndiaQuestionKind kind;
  final List<String> options;
  final String? picture;
}

const mapBasicsQuestions = [
  IndiaQuestion(
    id: 'map:shape',
    kind: IndiaQuestionKind.mapBasics,
    prompt: 'What does this map show?',
    answer: 'India',
    options: ['India', 'A flower'],
    teaching: 'This is the map of India. The outline shows its shape. India includes islands as well as the mainland.',
  ),
  IndiaQuestion(
    id: 'map:states',
    kind: IndiaQuestionKind.mapBasics,
    prompt: 'What do the coloured areas show?',
    answer: 'States and union territories',
    options: ['States and union territories', 'Different planets'],
    teaching: 'India has 28 states and 8 union territories. Their boundaries divide the map into places we can explore.',
  ),
  IndiaQuestion(
    id: 'map:north',
    kind: IndiaQuestionKind.mapBasics,
    prompt: 'On this map, where is north?',
    answer: 'Towards the top',
    options: ['Towards the top', 'Towards the bottom'],
    teaching: 'North is towards the top of this map. South is towards the bottom. East is right and west is left.',
  ),
  IndiaQuestion(
    id: 'map:sea',
    kind: IndiaQuestionKind.mapBasics,
    prompt: 'Which ocean lies south of India?',
    answer: 'Indian Ocean',
    options: ['Indian Ocean', 'Arctic Ocean'],
    teaching: 'The Indian Ocean lies south of India. The Arabian Sea is to the west and the Bay of Bengal is to the east.',
  ),
  IndiaQuestion(
    id: 'map:capital',
    kind: IndiaQuestionKind.mapBasics,
    prompt: 'What is the capital of India?',
    answer: 'New Delhi',
    options: ['New Delhi', 'Jaipur'],
    teaching: 'New Delhi is the capital of India. A capital is a city where important government offices work.',
  ),
  IndiaQuestion(
    id: 'map:islands',
    kind: IndiaQuestionKind.mapBasics,
    prompt: 'Are India’s islands also part of India?',
    answer: 'Yes',
    options: ['Yes', 'No'],
    teaching: 'Yes! Lakshadweep and the Andaman and Nicobar Islands are parts of India. They are shown in their real positions on our map.',
  ),
];

List<IndiaQuestion> indiaQuestions(AgeBand band) {
  final older = band == AgeBand.c || band == AgeBand.d;
  final states = explorerPlaces.where((p) => p.type == 'State').toList();
  return [
    ...mapBasicsQuestions.where(
      (q) =>
          band != AgeBand.toddler ||
          q.id == 'map:shape' ||
          q.id == 'map:islands',
    ),
    if (band != AgeBand.toddler)
      for (final p in states)
        IndiaQuestion(
          id: 'locate:${p.name}',
          kind: IndiaQuestionKind.locate,
          prompt: 'Can you find ${p.name} on the map?',
          answer: p.name,
          teaching: 'This highlighted place is ${p.name}. ${p.fact}',
        ),
    if (older)
      for (final p in explorerPlaces)
        IndiaQuestion(
          id: 'capital:${p.name}',
          kind: IndiaQuestionKind.capital,
          prompt: p.name == 'Jammu and Kashmir'
              ? 'Which pair names the seasonal capitals of Jammu and Kashmir?'
              : 'Which city is ${p.name == 'Maharashtra' ? 'the main capital' : 'a capital'} of ${p.name}?',
          answer: indiaCapitals[p.name]!,
          options: [
            indiaCapitals[p.name]!,
            p.name == 'Rajasthan' ? 'Chennai' : 'Jaipur',
          ],
          teaching:
              capitalNotes[p.name] ??
              '${indiaCapitals[p.name]} is the capital of ${p.name}.',
        ),
    for (final p in explorerNeighbours)
      IndiaQuestion(
        id: 'neighbour:${p.name}',
        kind: IndiaQuestionKind.neighbour,
        prompt: '${p.name} is which kind of neighbour?',
        answer: p.type == 'Land neighbour'
            ? 'Land neighbour'
            : 'Nearby island country',
        options: ['Land neighbour', 'Nearby island country'],
        teaching:
            '${p.name}. ${p.fact} ${p.type == 'Land neighbour' ? 'It is listed as a land neighbour of India.' : 'It is a nearby island country, not a land-border neighbour.'}',
      ),
    for (final entry in explorerMonuments.entries) ...[
      IndiaQuestion(
        id: 'monument:${entry.key}:name',
        kind: IndiaQuestionKind.monument,
        prompt: 'What is this monument called?',
        answer: entry.value.title,
        options: entry.value.choices,
        picture: entry.key,
        teaching: '${entry.value.title}. ${entry.value.detail}',
      ),
      if (band != AgeBand.toddler)
        IndiaQuestion(
          id: 'monument:${entry.key}:state',
          kind: IndiaQuestionKind.monument,
          prompt:
              'Which state or union territory is home to ${entry.value.title}?',
          answer: monumentStates[entry.key]!,
          picture: entry.key,
          options: [
            monumentStates[entry.key]!,
            entry.key == 'shore-temple' ? 'Odisha' : 'Tamil Nadu',
          ],
          teaching:
              '${entry.value.title} is in ${monumentStates[entry.key]}. ${entry.value.detail}',
        ),
    ],
  ];
}

const monumentStates = {
  'taj-mahal': 'Uttar Pradesh',
  'sanchi': 'Madhya Pradesh',
  'konark': 'Odisha',
  'shore-temple': 'Tamil Nadu',
  'qutb-minar': 'Delhi',
  'red-fort': 'Delhi',
};

IndiaQuestion? indiaQuestionByActivityId(String id) {
  const prefix = 'india-learning:v1:';
  if (!id.startsWith(prefix)) return null;
  return indiaQuestions(AgeBand.d)
      .where((q) => q.id == id.substring(prefix.length))
      .firstOrNull;
}
