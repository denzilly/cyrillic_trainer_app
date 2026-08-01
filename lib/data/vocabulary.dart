import 'models/vocab_word.dart';

/// Category ids, in the order they should be shown in the category picker.
const List<String> vocabCategories = [
  'Greetings',
  'Numbers',
  'Animals',
  'Food',
  'Colors',
];

/// Starter Russian vocabulary list for Word Practice mode.
///
/// This is a first draft covering a handful of common categories; expect to
/// grow it significantly once the practice loop is working end-to-end.
const List<VocabWord> vocabulary = [
  // Greetings
  VocabWord(cyrillic: 'привет', accepted: ['privet'], english: 'hi (informal)', category: 'Greetings'),
  VocabWord(cyrillic: 'здравствуйте', accepted: ['zdravstvuyte', 'zdravstvuite'], english: 'hello (formal)', category: 'Greetings'),
  VocabWord(cyrillic: 'пока', accepted: ['poka'], english: 'bye', category: 'Greetings'),
  VocabWord(cyrillic: 'спасибо', accepted: ['spasibo'], english: 'thank you', category: 'Greetings'),
  VocabWord(cyrillic: 'пожалуйста', accepted: ['pozhaluysta', 'pozhaluista'], english: 'please / you\'re welcome', category: 'Greetings'),
  VocabWord(cyrillic: 'да', accepted: ['da'], english: 'yes', category: 'Greetings'),
  VocabWord(cyrillic: 'нет', accepted: ['net'], english: 'no', category: 'Greetings'),
  VocabWord(cyrillic: 'доброе утро', accepted: ['dobroe utro'], english: 'good morning', category: 'Greetings'),
  VocabWord(cyrillic: 'добрый вечер', accepted: ['dobryy vecher', 'dobryi vecher'], english: 'good evening', category: 'Greetings'),
  VocabWord(cyrillic: 'извините', accepted: ['izvinite'], english: 'excuse me / sorry', category: 'Greetings'),

  // Numbers
  VocabWord(cyrillic: 'один', accepted: ['odin'], english: 'one', category: 'Numbers'),
  VocabWord(cyrillic: 'два', accepted: ['dva'], english: 'two', category: 'Numbers'),
  VocabWord(cyrillic: 'три', accepted: ['tri'], english: 'three', category: 'Numbers'),
  VocabWord(cyrillic: 'четыре', accepted: ['chetyre'], english: 'four', category: 'Numbers'),
  VocabWord(cyrillic: 'пять', accepted: ['pyat', "pyat'"], english: 'five', category: 'Numbers'),
  VocabWord(cyrillic: 'шесть', accepted: ['shest', "shest'"], english: 'six', category: 'Numbers'),
  VocabWord(cyrillic: 'семь', accepted: ['sem', "sem'"], english: 'seven', category: 'Numbers'),
  VocabWord(cyrillic: 'восемь', accepted: ['vosem', "vosem'"], english: 'eight', category: 'Numbers'),
  VocabWord(cyrillic: 'девять', accepted: ['devyat', "devyat'"], english: 'nine', category: 'Numbers'),
  VocabWord(cyrillic: 'десять', accepted: ['desyat', "desyat'"], english: 'ten', category: 'Numbers'),

  // Animals
  VocabWord(cyrillic: 'кошка', accepted: ['koshka'], english: 'cat', category: 'Animals'),
  VocabWord(cyrillic: 'собака', accepted: ['sobaka'], english: 'dog', category: 'Animals'),
  VocabWord(cyrillic: 'лошадь', accepted: ['loshad'], english: 'horse', category: 'Animals'),
  VocabWord(cyrillic: 'корова', accepted: ['korova'], english: 'cow', category: 'Animals'),
  VocabWord(cyrillic: 'медведь', accepted: ['medved'], english: 'bear', category: 'Animals'),
  VocabWord(cyrillic: 'волк', accepted: ['volk'], english: 'wolf', category: 'Animals'),
  VocabWord(cyrillic: 'птица', accepted: ['ptitsa'], english: 'bird', category: 'Animals'),
  VocabWord(cyrillic: 'рыба', accepted: ['ryba'], english: 'fish', category: 'Animals'),
  VocabWord(cyrillic: 'заяц', accepted: ['zayats', 'zaiats'], english: 'hare / rabbit', category: 'Animals'),
  VocabWord(cyrillic: 'лиса', accepted: ['lisa'], english: 'fox', category: 'Animals'),

  // Food
  VocabWord(cyrillic: 'хлеб', accepted: ['khleb', 'hleb'], english: 'bread', category: 'Food'),
  VocabWord(cyrillic: 'молоко', accepted: ['moloko'], english: 'milk', category: 'Food'),
  VocabWord(cyrillic: 'яблоко', accepted: ['yabloko', 'jabloko'], english: 'apple', category: 'Food'),
  VocabWord(cyrillic: 'вода', accepted: ['voda'], english: 'water', category: 'Food'),
  VocabWord(cyrillic: 'сыр', accepted: ['syr'], english: 'cheese', category: 'Food'),
  VocabWord(cyrillic: 'мясо', accepted: ['myaso', 'miaso'], english: 'meat', category: 'Food'),
  VocabWord(cyrillic: 'суп', accepted: ['sup'], english: 'soup', category: 'Food'),
  VocabWord(cyrillic: 'чай', accepted: ['chay', 'chai'], english: 'tea', category: 'Food'),
  VocabWord(cyrillic: 'кофе', accepted: ['kofe'], english: 'coffee', category: 'Food'),
  VocabWord(cyrillic: 'яйцо', accepted: ['yaytso', 'jaitso'], english: 'egg', category: 'Food'),

  // Colors
  VocabWord(cyrillic: 'красный', accepted: ['krasnyy', 'krasnyi'], english: 'red', category: 'Colors'),
  VocabWord(cyrillic: 'синий', accepted: ['siniy', 'sinii'], english: 'blue', category: 'Colors'),
  VocabWord(cyrillic: 'зелёный', accepted: ['zelyonyy', 'zelenyy'], english: 'green', category: 'Colors'),
  VocabWord(cyrillic: 'жёлтый', accepted: ['zhyoltyy', 'zheltyy'], english: 'yellow', category: 'Colors'),
  VocabWord(cyrillic: 'чёрный', accepted: ['chyornyy', 'chernyy'], english: 'black', category: 'Colors'),
  VocabWord(cyrillic: 'белый', accepted: ['belyy', 'belyi'], english: 'white', category: 'Colors'),
  VocabWord(cyrillic: 'розовый', accepted: ['rozovyy', 'rozovyi'], english: 'pink', category: 'Colors'),
  VocabWord(cyrillic: 'оранжевый', accepted: ['oranzhevyy', 'oranzhevyi'], english: 'orange', category: 'Colors'),
  VocabWord(cyrillic: 'серый', accepted: ['seryy', 'seryi'], english: 'gray', category: 'Colors'),
  VocabWord(cyrillic: 'фиолетовый', accepted: ['fioletovyy', 'fioletovyi'], english: 'purple', category: 'Colors'),
];

/// Words belonging to any of the given [categories].
List<VocabWord> wordsInCategories(Iterable<String> categories) {
  final selected = categories.toSet();
  return vocabulary.where((w) => selected.contains(w.category)).toList();
}
