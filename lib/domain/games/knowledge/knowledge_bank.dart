import '../../models/age_band.dart';
import '../play/play_question.dart';

class KnowledgeFact {
  const KnowledgeFact(this.prompt, this.answer, this.distractors, this.hint);

  final String prompt;
  final String answer;
  final List<String> distractors;
  final String hint;
}

const knowledgePackVersion = 'knowledge:v1';

List<KnowledgeFact> knowledgeFactsFor(AgeBand band) {
  return switch (band) {
    AgeBand.a || AgeBand.toddler => _bandA,
    AgeBand.b => _bandB,
    AgeBand.c => _bandC,
    AgeBand.d => _bandD,
  };
}

class KnowledgeGenerator {
  const KnowledgeGenerator();

  static const generatorVersion = knowledgePackVersion;

  List<PlayQuestion> generate({
    required AgeBand band,
    required int seed,
    required int variant,
  }) {
    final facts = knowledgeFactsFor(band);
    final fact = facts[variant % facts.length];
    final labels = [fact.answer, ...fact.distractors];
    final order = [0, 1, 2];
    final shift = seed.abs() % order.length;
    final rotated = [
      for (var index = 0; index < order.length; index++)
        order[(index + shift) % order.length],
    ];
    final choices = <PlayChoice>[
      for (final index in rotated)
        PlayChoice(
          id: index == 0 ? 'answer' : 'other$index',
          label: labels[index],
          visual: _visual(labels[index]),
        ),
    ];
    return [
      PlayQuestion(
        prompt: fact.prompt,
        choices: choices,
        correctId: 'answer',
        firstHint: fact.hint,
        strongerHint: 'The answer is ${fact.answer}.',
        explanation: 'fact=${fact.answer}',
      ),
    ];
  }
}

ChoiceVisual _visual(String label) {
  final number = int.tryParse(label);
  if (number != null) {
    return NumeralVisual(number);
  }
  final trimmed = label.trim();
  final letter = trimmed.isEmpty ? '?' : trimmed[0].toUpperCase();
  return LetterVisual(letter);
}

const _bandA = <KnowledgeFact>[
  KnowledgeFact('Which animal says woof?', 'Dog', [
    'Cat',
    'Bird',
  ], 'It is a pet.'),
  KnowledgeFact('Which one is a fruit?', 'Apple', [
    'Car',
    'Hat',
  ], 'You can eat it.'),
  KnowledgeFact('Which one do we see in the day sky?', 'Sun', [
    'Sock',
    'Chair',
  ], 'It is bright.'),
  KnowledgeFact('Which one can you ride?', 'Bus', [
    'Apple',
    'Spoon',
  ], 'It has wheels.'),
  KnowledgeFact('Which one is for a foot?', 'Shoe', [
    'Banana',
    'Sun',
  ], 'You wear it.'),
  KnowledgeFact('Which animal can fly?', 'Bird', [
    'Dog',
    'Cat',
  ], 'It has wings.'),
  KnowledgeFact('Which one grows in a garden?', 'Rose', [
    'Car',
    'Shoe',
  ], 'It is a flower.'),
  KnowledgeFact('Which one do you sit on?', 'Chair', [
    'Apple',
    'Moon',
  ], 'It is furniture.'),
  KnowledgeFact('Which fruit is long and yellow?', 'Banana', [
    'Car',
    'Hat',
  ], 'Monkeys like it.'),
  KnowledgeFact('Which one do we see at night?', 'Moon', [
    'Bus',
    'Shoe',
  ], 'It is in the sky.'),
  KnowledgeFact('Which one has wheels on a road?', 'Car', [
    'Apple',
    'Chair',
  ], 'People drive it.'),
  KnowledgeFact('Which one is clothing?', 'Shirt', [
    'Mango',
    'Dog',
  ], 'You wear it.'),
  KnowledgeFact('Which animal says meow?', 'Cat', [
    'Dog',
    'Bird',
  ], 'It is a small pet.'),
  KnowledgeFact('Which one is a flower?', 'Tulip', [
    'Train',
    'Sock',
  ], 'It has petals.'),
  KnowledgeFact('Which one can you eat?', 'Mango', [
    'Hat',
    'Chair',
  ], 'It is a fruit.'),
  KnowledgeFact('Which one is a vehicle?', 'Train', [
    'Rose',
    'Spoon',
  ], 'It carries people.'),
  KnowledgeFact('Which one covers your head?', 'Hat', [
    'Apple',
    'Moon',
  ], 'You wear it.'),
  KnowledgeFact('Which pet barks?', 'Dog', ['Rose', 'Bus'], 'It says woof.'),
  KnowledgeFact('Which one is in the night sky?', 'Moon', [
    'Banana',
    'Shoe',
  ], 'It looks round.'),
  KnowledgeFact('Which one do you wear on a foot?', 'Sock', [
    'Sun',
    'Car',
  ], 'It is clothing.'),
  KnowledgeFact('Which one has petals?', 'Sunflower', [
    'Chair',
    'Bus',
  ], 'It is a flower.'),
  KnowledgeFact('Which one rolls on tracks?', 'Train', [
    'Cat',
    'Apple',
  ], 'It is a vehicle.'),
  KnowledgeFact('Which fruit is often red?', 'Apple', [
    'Bus',
    'Hat',
  ], 'You can eat it.'),
  KnowledgeFact('Which one is an animal?', 'Cat', [
    'Spoon',
    'Shirt',
  ], 'It can move by itself.'),
  KnowledgeFact('Which one helps you eat?', 'Spoon', [
    'Moon',
    'Shoe',
  ], 'It is used at meals.'),
];

const _bandB = <KnowledgeFact>[
  KnowledgeFact('A baby dog is called a', 'Puppy', [
    'Kitten',
    'Calf',
  ], 'It says woof when it grows up.'),
  KnowledgeFact('How many wheels does a bicycle have?', '2', [
    '3',
    '4',
  ], 'Count the wheels.'),
  KnowledgeFact('Which season is the coldest?', 'Winter', [
    'Summer',
    'Spring',
  ], 'People wear warm clothes.'),
  KnowledgeFact('What do plants need to grow?', 'Water', [
    'Rocks',
    'Toys',
  ], 'They drink it.'),
  KnowledgeFact('Which one tells the time?', 'Clock', [
    'Pillow',
    'Ball',
  ], 'It has numbers.'),
  KnowledgeFact('How many days are in a week?', '7', [
    '5',
    '10',
  ], 'Count Monday to Sunday.'),
  KnowledgeFact('A bird’s home is a', 'Nest', [
    'Kennel',
    'Stable',
  ], 'It is built in a tree.'),
  KnowledgeFact('Which meal is in the morning?', 'Breakfast', [
    'Dinner',
    'Lunch',
  ], 'It is the first meal.'),
  KnowledgeFact('Ice is frozen', 'Water', [
    'Sand',
    'Wood',
  ], 'It melts into a drink.'),
  KnowledgeFact('We smell with our', 'Nose', [
    'Ears',
    'Knees',
  ], 'It is on your face.'),
  KnowledgeFact('A ripe banana is', 'Yellow', [
    'Blue',
    'Black',
  ], 'Look at the peel.'),
  KnowledgeFact('A cow says', 'Moo', ['Woof', 'Meow'], 'It lives on a farm.'),
  KnowledgeFact('How many eyes do people have?', '2', [
    '1',
    '4',
  ], 'Count them on a face.'),
  KnowledgeFact('Rain comes from', 'Clouds', [
    'Shoes',
    'Chairs',
  ], 'They are in the sky.'),
  KnowledgeFact('Which shape has three sides?', 'Triangle', [
    'Circle',
    'Square',
  ], 'Count the sides.'),
  KnowledgeFact('Fish live in', 'Water', ['Nests', 'Shoes'], 'They swim.'),
  KnowledgeFact('We read a', 'Book', ['Spoon', 'Sock'], 'It has pages.'),
  KnowledgeFact('The sun rises in the', 'Morning', [
    'Night',
    'Midnight',
  ], 'The day starts then.'),
  KnowledgeFact('A baby cat is a', 'Kitten', [
    'Puppy',
    'Calf',
  ], 'It says meow later.'),
  KnowledgeFact('How many fingers are on one hand?', '5', [
    '3',
    '8',
  ], 'Count them.'),
  KnowledgeFact('Leaves are often', 'Green', [
    'Purple',
    'Silver',
  ], 'They grow on plants.'),
  KnowledgeFact('We hear with our', 'Ears', [
    'Nose',
    'Elbows',
  ], 'They are on the sides of your head.'),
  KnowledgeFact('A train runs on', 'Tracks', [
    'Water',
    'Clouds',
  ], 'The rails are metal.'),
  KnowledgeFact('Honey comes from', 'Bees', [
    'Fish',
    'Cats',
  ], 'They live in a hive.'),
  KnowledgeFact('A pair is how many?', '2', ['9', '7'], 'Like two shoes.'),
];

const _bandC = <KnowledgeFact>[
  KnowledgeFact('The capital of India is', 'New Delhi', [
    'Mumbai',
    'Chennai',
  ], 'It is the capital city.'),
  KnowledgeFact('How many months are in a year?', '12', [
    '10',
    '7',
  ], 'Count January to December.'),
  KnowledgeFact('Water freezes into', 'Ice', [
    'Steam',
    'Sand',
  ], 'It becomes hard and cold.'),
  KnowledgeFact('A triangle has how many sides?', '3', [
    '4',
    '5',
  ], 'Count the straight sides.'),
  KnowledgeFact('The opposite of hot is', 'Cold', [
    'Warm',
    'Bright',
  ], 'Ice feels this way.'),
  KnowledgeFact('Which planet do we live on?', 'Earth', [
    'Mars',
    'Moon',
  ], 'It is our home planet.'),
  KnowledgeFact('A week has how many days?', '7', [
    '5',
    '9',
  ], 'Count the days.'),
  KnowledgeFact('Cows give us', 'Milk', ['Wool', 'Honey'], 'It is a drink.'),
  KnowledgeFact('Blue and yellow mixed make', 'Green', [
    'Red',
    'Black',
  ], 'Like many leaves.'),
  KnowledgeFact('How many hours are on a clock face?', '12', [
    '10',
    '24',
  ], 'Count the numbers on a clock.'),
  KnowledgeFact('A square has how many equal sides?', '4', [
    '3',
    '6',
  ], 'Count the sides.'),
  KnowledgeFact('Birds are covered with', 'Feathers', [
    'Fur',
    'Scales',
  ], 'They help a bird fly.'),
  KnowledgeFact('We breathe with our', 'Lungs', [
    'Stomach',
    'Bones',
  ], 'They fill with air.'),
  KnowledgeFact('Which of these is the biggest animal?', 'Whale', [
    'Ant',
    'Sparrow',
  ], 'It lives in the ocean.'),
  KnowledgeFact('Seeds grow into', 'Plants', [
    'Rocks',
    'Clouds',
  ], 'They need water and light.'),
  KnowledgeFact('Night follows', 'Day', ['Winter', 'Lunch'], 'After sunset.'),
  KnowledgeFact('A rainbow can appear after', 'Rain', [
    'Desks',
    'Pillows',
  ], 'The sun shines on water drops.'),
  KnowledgeFact('India’s Independence Day is in', 'August', [
    'January',
    'March',
  ], 'It is a national day.'),
  KnowledgeFact('How many zeroes are in ten?', '1', [
    '2',
    '0',
  ], 'Look at the number 10.'),
  KnowledgeFact('The moon orbits the', 'Earth', [
    'Mars',
    'Venus',
  ], 'We see it from our planet.'),
  KnowledgeFact('Wool comes from', 'Sheep', [
    'Fish',
    'Bees',
  ], 'It is used for warm clothes.'),
  KnowledgeFact('A map shows', 'Places', [
    'Flavors',
    'Songs',
  ], 'It helps you find a way.'),
  KnowledgeFact('The first letter of apple is', 'A', [
    'B',
    'C',
  ], 'Say the word slowly.'),
  KnowledgeFact('Half of ten is', '5', [
    '4',
    '8',
  ], 'Split ten into two equal parts.'),
  KnowledgeFact('Which one is a bird?', 'Sparrow', [
    'Shark',
    'Lizard',
  ], 'It has feathers.'),
];

const _bandD = <KnowledgeFact>[
  KnowledgeFact('How many continents are there?', '7', [
    '5',
    '6',
  ], 'Count the big land areas.'),
  KnowledgeFact('Water boils at', '100 °C', [
    '0 °C',
    '50 °C',
  ], 'This is the boiling point.'),
  KnowledgeFact('Which gas do we breathe in?', 'Oxygen', [
    'Helium',
    'Neon',
  ], 'Our lungs use it.'),
  KnowledgeFact('A common year has how many days?', '365', [
    '100',
    '30',
  ], 'Count the days in a year.'),
  KnowledgeFact('The sun is a', 'Star', [
    'Planet',
    'Moon',
  ], 'It makes its own light.'),
  KnowledgeFact('Plants make food mainly in their', 'Leaves', [
    'Bones',
    'Rocks',
  ], 'The green parts do this.'),
  KnowledgeFact('How many sides does a hexagon have?', '6', [
    '5',
    '8',
  ], 'Hex means six.'),
  KnowledgeFact('The Nile is a', 'River', [
    'Mountain',
    'Desert',
  ], 'Water flows along it.'),
  KnowledgeFact('Sound can travel through', 'Air', [
    'Thoughts',
    'Silence',
  ], 'We hear it around us.'),
  KnowledgeFact('A decade is how many years?', '10', [
    '100',
    '5',
  ], 'Ten years make one.'),
  KnowledgeFact('The heart pumps', 'Blood', [
    'Air',
    'Food',
  ], 'It moves around the body.'),
  KnowledgeFact('Which of these is a prime number?', '5', [
    '4',
    '9',
  ], 'It has only two factors.'),
  KnowledgeFact('India is in which continent?', 'Asia', [
    'Europe',
    'Africa',
  ], 'Look at a world map.'),
  KnowledgeFact('An antonym of empty is', 'Full', [
    'Hollow',
    'Tiny',
  ], 'It means the opposite.'),
  KnowledgeFact('How many minutes are in an hour?', '60', [
    '30',
    '24',
  ], 'Count them on a clock.'),
  KnowledgeFact('The Earth orbits the', 'Sun', [
    'Moon',
    'Mars',
  ], 'One trip takes a year.'),
  KnowledgeFact('A tadpole becomes a', 'Frog', [
    'Bird',
    'Shark',
  ], 'It grows legs.'),
  KnowledgeFact('Which number is the largest?', '48', [
    '39',
    '27',
  ], 'Compare the tens.'),
  KnowledgeFact('Magnets attract', 'Iron', [
    'Wood',
    'Plastic',
  ], 'A paperclip is this metal.'),
  KnowledgeFact('A synonym of happy is', 'Glad', [
    'Angry',
    'Sleepy',
  ], 'It means the same feeling.'),
  KnowledgeFact('How many zeroes are in one hundred?', '2', [
    '1',
    '3',
  ], 'Look at 100.'),
  KnowledgeFact('The Pacific is an', 'Ocean', [
    'Island',
    'Forest',
  ], 'It is a huge body of water.'),
  KnowledgeFact('Plants use which of these to make food?', 'Sunlight', [
    'Darkness',
    'Ice',
  ], 'They need light.'),
  KnowledgeFact('A right angle measures', '90 degrees', [
    '45 degrees',
    '10 degrees',
  ], 'It is a square corner.'),
  KnowledgeFact('Which month comes after March?', 'April', [
    'June',
    'January',
  ], 'Say the months in order.'),
];
