import 'india_learning_content.dart';

/// Short, age-appropriate public facts. Languages are the main official
/// state language commonly taught to children, not a full language census.
class StateCulture {
  const StateCulture(this.language, this.tradition, this.note);
  final String language, tradition, note;
}

const stateCultures = <String, StateCulture>{
  'Andhra Pradesh': StateCulture('Telugu', 'Ugadi and harvest festivals', 'Coastal plains and the Krishna–Godavari delta.'),
  'Arunachal Pradesh': StateCulture('English with many local languages', 'Losar and community dances', 'Hills in India’s far northeast.'),
  'Assam': StateCulture('Assamese', 'Bihu', 'The Brahmaputra River is central to life here.'),
  'Bihar': StateCulture('Hindi', 'Chhath Puja', 'The Ganga River flows across the plains.'),
  'Chhattisgarh': StateCulture('Hindi', 'Harvest fairs and folk dance', 'Forests and plateaus in central India.'),
  'Goa': StateCulture('Konkani', 'Carnival and church feasts', 'A small state beside the Arabian Sea.'),
  'Gujarat': StateCulture('Gujarati', 'Navratri garba', 'The Rann of Kutch is a famous salt desert.'),
  'Haryana': StateCulture('Hindi', 'Harvest songs and wrestling akharas', 'Farmland around the National Capital Region.'),
  'Himachal Pradesh': StateCulture('Hindi', 'Hill fairs and Kullu Dussehra', 'Himalayan valleys and apple orchards.'),
  'Jharkhand': StateCulture('Hindi', 'Sarhul and community groves', 'Plateaus and forests next to Bihar.'),
  'Karnataka': StateCulture('Kannada', 'Dasara in Mysuru', 'Bengaluru is a large technology city.'),
  'Kerala': StateCulture('Malayalam', 'Onam', 'Backwaters and a long Arabian Sea coast.'),
  'Madhya Pradesh': StateCulture('Hindi', 'Khajuraho dance festival', 'Central highlands and many tiger reserves.'),
  'Maharashtra': StateCulture('Marathi', 'Ganesh Chaturthi', 'Mumbai is India’s largest city by population.'),
  'Manipur': StateCulture('Manipuri', 'Lai Haraoba and Ras Lila', 'A valley state in the northeast.'),
  'Meghalaya': StateCulture('English with Khasi and Garo', 'Wangala and living root bridges', 'One of the wettest inhabited regions on Earth.'),
  'Mizoram': StateCulture('Mizo', 'Chapchar Kut', 'Hills along India’s eastern border.'),
  'Nagaland': StateCulture('English with many Naga languages', 'Hornbill Festival', 'Hills in the far northeast.'),
  'Odisha': StateCulture('Odia', 'Rath Yatra in Puri', 'The Bay of Bengal coast and Konark.'),
  'Punjab': StateCulture('Punjabi', 'Baisakhi', 'Wheat fields and the five rivers of the Punjab.'),
  'Rajasthan': StateCulture('Hindi', 'Desert fairs and folk music', 'The Thar Desert is in the west.'),
  'Sikkim': StateCulture('Nepali, Sikkimese and others', 'Losar and Pang Lhabsol', 'A Himalayan state that includes Kanchenjunga.'),
  'Tamil Nadu': StateCulture('Tamil', 'Pongal', 'Ancient temple towns and a long east coast.'),
  'Telangana': StateCulture('Telugu', 'Bathukamma', 'Hyderabad is a major Deccan city.'),
  'Tripura': StateCulture('Bengali and Kokborok', 'Kharchi Puja', 'A small northeastern state.'),
  'Uttar Pradesh': StateCulture('Hindi', 'Kumbh Mela and Holi', 'The Ganga and Yamuna meet at Prayagraj.'),
  'Uttarakhand': StateCulture('Hindi', 'Hill pilgrimages and fairs', 'The Ganga begins in these Himalayan hills.'),
  'West Bengal': StateCulture('Bengali', 'Durga Puja', 'The Sundarbans mangrove forest is here.'),
  'Delhi': StateCulture('Hindi', 'Republic Day parade', 'New Delhi is the capital of India.'),
  'Jammu and Kashmir': StateCulture('Kashmiri, Dogri and others', 'Tulip festival and winter capital move', 'Seasonal capitals: Srinagar and Jammu.'),
  'Ladakh': StateCulture('Ladakhi and others', 'Hemis festival', 'A high cold desert union territory.'),
  'Puducherry': StateCulture('Tamil, with French heritage', 'Bastille Day and temple festivals', 'A union territory on the east coast.'),
  'Chandigarh': StateCulture('Hindi and Punjabi', 'Rose Festival', 'Shared capital of Punjab and Haryana.'),
  'Andaman and Nicobar Islands': StateCulture('Hindi and many island languages', 'Island festivals', 'Islands in the Bay of Bengal.'),
  'Dadra and Nagar Haveli and Daman and Diu': StateCulture('Gujarati, Hindi and others', 'Coastal and tribal festivals', 'A merged union territory on the west coast.'),
  'Lakshadweep': StateCulture('Malayalam', 'Island boat races and Eid', 'Coral islands in the Arabian Sea.'),
};

String cultureBlurb(String name) {
  final culture = stateCultures[name];
  if (culture == null) {
    return '';
  }
  return 'Language: ${culture.language}. Tradition: ${culture.tradition}. ${culture.note}';
}

final extraIndiaQuestions = <IndiaQuestion>[
  IndiaQuestion(id: 'river:ganga', kind: IndiaQuestionKind.river, prompt: 'Which great river is holy to many people and flows across the northern plains?', answer: 'Ganga', options: ['Ganga', 'Narmada'], teaching: 'The Ganga begins in the Himalaya of Uttarakhand and flows east to the Bay of Bengal. People farm and live along its plains.'),
  IndiaQuestion(id: 'river:yamuna', kind: IndiaQuestionKind.river, prompt: 'Which river flows past Agra and later joins the Ganga?', answer: 'Yamuna', options: ['Yamuna', 'Kaveri'], teaching: 'The Yamuna is a main tributary of the Ganga. The Taj Mahal stands beside it in Agra.'),
  IndiaQuestion(id: 'river:brahmaputra', kind: IndiaQuestionKind.river, prompt: 'Which wide river flows through Assam?', answer: 'Brahmaputra', options: ['Brahmaputra', 'Tapti'], teaching: 'The Brahmaputra enters India in Arunachal Pradesh and is central to Assam’s farms and floods.'),
  IndiaQuestion(id: 'river:godavari', kind: IndiaQuestionKind.river, prompt: 'Which is the longest river of peninsular India?', answer: 'Godavari', options: ['Godavari', 'Sabarmati'], teaching: 'The Godavari rises in Maharashtra and reaches the Bay of Bengal in Andhra Pradesh.'),
  IndiaQuestion(id: 'river:narmada', kind: IndiaQuestionKind.river, prompt: 'Which river flows west into the Arabian Sea?', answer: 'Narmada', options: ['Narmada', 'Kosi'], teaching: 'Most long Indian rivers flow east. The Narmada and Tapti are famous west-flowing rivers.'),
  IndiaQuestion(id: 'river:kaveri', kind: IndiaQuestionKind.river, prompt: 'Which river is important to Tamil Nadu and Karnataka farms?', answer: 'Kaveri', options: ['Kaveri', 'Beas'], teaching: 'The Kaveri rises in the Western Ghats and waters the southern plains.'),
  IndiaQuestion(id: 'lake:chilika', kind: IndiaQuestionKind.lake, prompt: 'Which is India’s largest coastal lagoon?', answer: 'Chilika Lake', options: ['Chilika Lake', 'Dal Lake'], teaching: 'Chilika Lake in Odisha is a huge brackish lagoon. Birds winter here.'),
  IndiaQuestion(id: 'lake:wular', kind: IndiaQuestionKind.lake, prompt: 'Which is one of India’s largest freshwater lakes, in Jammu and Kashmir?', answer: 'Wular Lake', options: ['Wular Lake', 'Sambhar Lake'], teaching: 'Wular Lake sits in the Kashmir Valley and is fed by the Jhelum River.'),
  IndiaQuestion(id: 'lake:sambhar', kind: IndiaQuestionKind.lake, prompt: 'Which Rajasthan lake is known for salt?', answer: 'Sambhar Lake', options: ['Sambhar Lake', 'Loktak Lake'], teaching: 'Sambhar is a salt lake. People collect salt from its bed.'),
  IndiaQuestion(id: 'lake:loktak', kind: IndiaQuestionKind.lake, prompt: 'Which Manipur lake is known for floating islands?', answer: 'Loktak Lake', options: ['Loktak Lake', 'Chilika Lake'], teaching: 'Loktak Lake has phumdis, floating mats of plants. It is a unique wetland.'),
  IndiaQuestion(id: 'lake:dal', kind: IndiaQuestionKind.lake, prompt: 'Which Srinagar lake is famous for houseboats?', answer: 'Dal Lake', options: ['Dal Lake', 'Pulicat Lake'], teaching: 'Dal Lake is in Srinagar. People live and travel on houseboats there.'),
  IndiaQuestion(id: 'dam:bhakra', kind: IndiaQuestionKind.dam, prompt: 'Which tall dam is on the Sutlej River?', answer: 'Bhakra Nangal', options: ['Bhakra Nangal', 'Hirakud'], teaching: 'Bhakra Nangal stores water for farms and electricity in northern India.'),
  IndiaQuestion(id: 'dam:hirakud', kind: IndiaQuestionKind.dam, prompt: 'Which long dam is on the Mahanadi in Odisha?', answer: 'Hirakud', options: ['Hirakud', 'Tehri'], teaching: 'Hirakud is one of the world’s longest earthen dams. It helps control floods and water farms.'),
  IndiaQuestion(id: 'dam:sardar', kind: IndiaQuestionKind.dam, prompt: 'Which Gujarat dam is on the Narmada?', answer: 'Sardar Sarovar', options: ['Sardar Sarovar', 'Koyna'], teaching: 'Sardar Sarovar stores Narmada water for drinking, farms and power.'),
  IndiaQuestion(id: 'dam:tehri', kind: IndiaQuestionKind.dam, prompt: 'Which tall dam is in Uttarakhand on the Bhagirathi?', answer: 'Tehri', options: ['Tehri', 'Mettur'], teaching: 'Tehri Dam is a high rock-fill dam. It makes electricity and stores Himalayan water.'),
  IndiaQuestion(id: 'city:mumbai', kind: IndiaQuestionKind.city, prompt: 'Which city is Maharashtra’s main capital and a huge port?', answer: 'Mumbai', options: ['Mumbai', 'Nagpur'], teaching: 'Mumbai is on the Arabian Sea. It is India’s largest city by population and a major port.'),
  IndiaQuestion(id: 'city:kolkata', kind: IndiaQuestionKind.city, prompt: 'Which metro city is the capital of West Bengal?', answer: 'Kolkata', options: ['Kolkata', 'Patna'], teaching: 'Kolkata sits on the Hooghly River. It is a large eastern metro city.'),
  IndiaQuestion(id: 'city:chennai', kind: IndiaQuestionKind.city, prompt: 'Which metro city is the capital of Tamil Nadu?', answer: 'Chennai', options: ['Chennai', 'Madurai'], teaching: 'Chennai is on the Bay of Bengal. It is a southern metro city and port.'),
  IndiaQuestion(id: 'city:bengaluru', kind: IndiaQuestionKind.city, prompt: 'Which metro city is the capital of Karnataka?', answer: 'Bengaluru', options: ['Bengaluru', 'Mysuru'], teaching: 'Bengaluru is on the Deccan Plateau. Many technology offices work there.'),
  IndiaQuestion(id: 'city:hyderabad', kind: IndiaQuestionKind.city, prompt: 'Which metro city is the capital of Telangana?', answer: 'Hyderabad', options: ['Hyderabad', 'Warangal'], teaching: 'Hyderabad is a Deccan metro city. It is Telangana’s capital.'),
  IndiaQuestion(id: 'city:ahmedabad', kind: IndiaQuestionKind.city, prompt: 'Which large Gujarat city sits on the Sabarmati River?', answer: 'Ahmedabad', options: ['Ahmedabad', 'Surat'], teaching: 'Ahmedabad is a major western metro city. Gandhinagar is Gujarat’s capital nearby.'),
  IndiaQuestion(id: 'city:pune', kind: IndiaQuestionKind.city, prompt: 'Which large Maharashtra city lies east of the Western Ghats?', answer: 'Pune', options: ['Pune', 'Nashik'], teaching: 'Pune is a large inland city. Students and factories work there.'),
  IndiaQuestion(id: 'monument:taj:who', kind: IndiaQuestionKind.monument, prompt: 'Who commissioned the Taj Mahal?', answer: 'Shah Jahan', options: ['Shah Jahan', 'Ashoka'], teaching: 'Emperor Shah Jahan had the Taj Mahal built in Agra in memory of Mumtaz Mahal. It is a tomb of white marble beside the Yamuna. UNESCO lists it for its architecture. We look at its beauty and history, not at war.'),
  IndiaQuestion(id: 'monument:taj:why', kind: IndiaQuestionKind.monument, prompt: 'Why was the Taj Mahal built?', answer: 'As a tomb', options: ['As a tomb', 'As a fort'], teaching: 'It is a mausoleum. Families still visit to remember love, craft and the Yamuna riverside city of Agra.'),
  IndiaQuestion(id: 'monument:redfort:who', kind: IndiaQuestionKind.monument, prompt: 'Who founded the Red Fort in Delhi?', answer: 'Shah Jahan', options: ['Shah Jahan', 'Rajaraja I'], teaching: 'Shah Jahan founded the Red Fort as a palace-fort for Shahjahanabad. The Prime Minister speaks from its ramparts on Independence Day. That is its civic impact today.'),
  IndiaQuestion(id: 'monument:qutb:who', kind: IndiaQuestionKind.monument, prompt: 'The Qutb Minar was begun under which early Delhi ruler’s era?', answer: 'Qutb-ud-din Aibak', options: ['Qutb-ud-din Aibak', 'Akbar'], teaching: 'Work began in the late 1100s under Qutb-ud-din Aibak and continued later. The tower shows carved sandstone bands. UNESCO protects the Qutb complex.'),
  IndiaQuestion(id: 'monument:sanchi:who', kind: IndiaQuestionKind.monument, prompt: 'Which emperor is linked with enlarging Sanchi Stupa?', answer: 'Ashoka', options: ['Ashoka', 'Shah Jahan'], teaching: 'The Great Stupa at Sanchi is a Buddhist monument. Ashoka’s time is linked with early stupas. Carved gateways teach stories without speaking.'),
  IndiaQuestion(id: 'monument:konark:why', kind: IndiaQuestionKind.monument, prompt: 'The Konark temple is dedicated to which deity?', answer: 'The Sun', options: ['The Sun', 'The Moon'], teaching: 'Konark Sun Temple was built as a stone chariot for Surya. Its wheels and horses are famous carvings. It stands on Odisha’s coast.'),
  IndiaQuestion(id: 'monument:shore:who', kind: IndiaQuestionKind.monument, prompt: 'The Shore Temple at Mahabalipuram is linked with which dynasty?', answer: 'Pallava', options: ['Pallava', 'Mughal'], teaching: 'Pallava kings built stone temples by the sea. Salt wind and waves are why the site is carefully conserved.'),
  IndiaQuestion(id: 'culture:punjab', kind: IndiaQuestionKind.culture, prompt: 'Which language is mainly taught and spoken in Punjab?', answer: 'Punjabi', options: ['Punjabi', 'Tamil'], teaching: cultureBlurb('Punjab')),
  IndiaQuestion(id: 'culture:kerala', kind: IndiaQuestionKind.culture, prompt: 'Onam is a famous harvest festival of which state?', answer: 'Kerala', options: ['Kerala', 'Punjab'], teaching: cultureBlurb('Kerala')),
  IndiaQuestion(id: 'culture:tn', kind: IndiaQuestionKind.culture, prompt: 'Which language is mainly followed in Tamil Nadu?', answer: 'Tamil', options: ['Tamil', 'Odia'], teaching: cultureBlurb('Tamil Nadu')),
  IndiaQuestion(id: 'culture:wb', kind: IndiaQuestionKind.culture, prompt: 'Durga Puja is a major festival of which state?', answer: 'West Bengal', options: ['West Bengal', 'Goa'], teaching: cultureBlurb('West Bengal')),
  IndiaQuestion(id: 'culture:mh', kind: IndiaQuestionKind.culture, prompt: 'Ganesh Chaturthi is widely celebrated in which state?', answer: 'Maharashtra', options: ['Maharashtra', 'Sikkim'], teaching: cultureBlurb('Maharashtra')),
  IndiaQuestion(id: 'culture:gj', kind: IndiaQuestionKind.culture, prompt: 'Navratri garba is famous in which state?', answer: 'Gujarat', options: ['Gujarat', 'Nagaland'], teaching: cultureBlurb('Gujarat')),
  IndiaQuestion(id: 'culture:rj', kind: IndiaQuestionKind.culture, prompt: 'The Thar Desert lies mainly in which state?', answer: 'Rajasthan', options: ['Rajasthan', 'Kerala'], teaching: cultureBlurb('Rajasthan')),
  IndiaQuestion(id: 'culture:ka', kind: IndiaQuestionKind.culture, prompt: 'Kannada is the main language of which state?', answer: 'Karnataka', options: ['Karnataka', 'Assam'], teaching: cultureBlurb('Karnataka')),
  IndiaQuestion(id: 'culture:ap', kind: IndiaQuestionKind.culture, prompt: 'Telugu is the main language of Andhra Pradesh and which other state?', answer: 'Telangana', options: ['Telangana', 'Goa'], teaching: '${cultureBlurb('Telangana')} Andhra Pradesh also uses Telugu.'),
  IndiaQuestion(id: 'culture:as', kind: IndiaQuestionKind.culture, prompt: 'Bihu is a festival of which state?', answer: 'Assam', options: ['Assam', 'Goa'], teaching: cultureBlurb('Assam')),
  IndiaQuestion(id: 'geo:himalaya', kind: IndiaQuestionKind.mapBasics, prompt: 'Which great mountain range lies along much of India’s north?', answer: 'The Himalaya', options: ['The Himalaya', 'The Alps'], teaching: 'The Himalaya form a high wall in the north. Many rivers start as snow-melt there.'),
  IndiaQuestion(id: 'geo:thar', kind: IndiaQuestionKind.mapBasics, prompt: 'Which desert is in western India?', answer: 'Thar Desert', options: ['Thar Desert', 'Sahara'], teaching: 'The Thar Desert is mostly in Rajasthan. People live there with careful water use.'),
  IndiaQuestion(id: 'geo:western-ghats', kind: IndiaQuestionKind.mapBasics, prompt: 'Which hills run along India’s west coast?', answer: 'Western Ghats', options: ['Western Ghats', 'Aravalli only'], teaching: 'The Western Ghats catch monsoon rain. They are a biodiversity hotspot.'),
  IndiaQuestion(id: 'geo:deccan', kind: IndiaQuestionKind.mapBasics, prompt: 'What do we call the large plateau of southern India?', answer: 'Deccan Plateau', options: ['Deccan Plateau', 'Indo-Gangetic Plain'], teaching: 'The Deccan Plateau is older rock in the south. Cities like Hyderabad and Bengaluru sit on it.'),
  IndiaQuestion(id: 'geo:sundarbans', kind: IndiaQuestionKind.mapBasics, prompt: 'The Sundarbans mangrove forest is mainly in which state?', answer: 'West Bengal', options: ['West Bengal', 'Gujarat'], teaching: 'The Sundarbans are tidal mangrove forests where the Ganga meets the sea. Tigers live there.'),
  IndiaQuestion(id: 'geo:andaman-sea', kind: IndiaQuestionKind.mapBasics, prompt: 'The Andaman and Nicobar Islands lie in which sea?', answer: 'Bay of Bengal', options: ['Bay of Bengal', 'Arabian Sea'], teaching: 'These islands are east of the mainland, in the Bay of Bengal. They are part of India.'),
  IndiaQuestion(id: 'geo:lakshadweep-sea', kind: IndiaQuestionKind.mapBasics, prompt: 'Lakshadweep lies in which sea?', answer: 'Arabian Sea', options: ['Arabian Sea', 'Bay of Bengal'], teaching: 'Lakshadweep is a group of coral islands west of Kerala, in the Arabian Sea.'),
  IndiaQuestion(id: 'city:delhi', kind: IndiaQuestionKind.city, prompt: 'Which city area is the capital of India?', answer: 'New Delhi', options: ['New Delhi', 'Mumbai'], teaching: 'New Delhi is inside the National Capital Territory of Delhi. Parliament and Rashtrapati Bhavan are there.'),
  IndiaQuestion(id: 'city:jaipur', kind: IndiaQuestionKind.city, prompt: 'Which city is the capital of Rajasthan?', answer: 'Jaipur', options: ['Jaipur', 'Jodhpur'], teaching: 'Jaipur is called the Pink City. It is Rajasthan’s capital.'),
  IndiaQuestion(id: 'city:bhopal', kind: IndiaQuestionKind.city, prompt: 'Which city is the capital of Madhya Pradesh?', answer: 'Bhopal', options: ['Bhopal', 'Indore'], teaching: 'Bhopal is the capital. Indore is another large city in the same state.'),
  IndiaQuestion(id: 'city:lucknow', kind: IndiaQuestionKind.city, prompt: 'Which city is the capital of Uttar Pradesh?', answer: 'Lucknow', options: ['Lucknow', 'Agra'], teaching: 'Lucknow is the capital. Agra is famous for the Taj Mahal but is not the capital.'),
];
