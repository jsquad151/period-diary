/// Controlled vocabularies for observations.
///
/// Values are stored in the database and exports as stable [Option.key]
/// strings; [Option.label] is what the user sees. Never rename a key once
/// data exists, only add new ones.
class Option {
  const Option(this.key, this.label);
  final String key;
  final String label;
}

String labelFor(List<Option> options, String key) {
  for (final o in options) {
    if (o.key == key) return o.label;
  }
  return key;
}

const sourceRealtime = 'realtime';
const sourceReconstructed = 'reconstructed';

/// What the user noticed (brief §19, §21).
const materialTypes = [
  Option('discharge', 'Discharge / fluid'),
  Option('brown', 'Brown material'),
  Option('pink', 'Pink material'),
  Option('blood', 'Red blood'),
  Option('mucus', 'Mucus'),
  Option('clot', 'Clot'),
  Option('tissue_like', 'Tissue-like material'),
  Option('uncertain', 'Not sure'),
  Option('other', 'Other'),
];

const fluidColours = [
  Option('clear', 'Clear'),
  Option('white', 'White'),
  Option('cream', 'Cream'),
  Option('pale_pink', 'Pale pink'),
  Option('pink', 'Pink'),
  Option('bright_red', 'Bright red'),
  Option('red', 'Red'),
  Option('dark_red', 'Dark red'),
  Option('red_brown', 'Red-brown'),
  Option('light_brown', 'Light brown'),
  Option('brown', 'Brown'),
  Option('dark_brown', 'Dark brown'),
  Option('near_black', 'Very dark / near-black'),
  Option('yellow', 'Yellow'),
  Option('grey', 'Grey'),
  Option('green', 'Green'),
  Option('other', 'Other'),
];

const fluidAmounts = [
  Option('trace', 'Trace'),
  Option('very_small', 'Very small'),
  Option('small', 'Small'),
  Option('moderate', 'Moderate'),
  Option('large', 'Large'),
  Option('very_large', 'Very large'),
];

const visibilityContexts = [
  Option('wiping', 'Only noticed when wiping'),
  Option('underwear', 'Visible on underwear'),
  Option('liner_noticeable', 'Noticeable on pantyliner'),
  Option('needed_liner', 'Needed pantyliner'),
  Option('needed_pad', 'Needed pad'),
  Option('needed_tampon', 'Needed tampon'),
  Option('toilet', 'Visible in toilet'),
  Option('leaked', 'Leaked through protection'),
  Option('other', 'Other'),
];

const fluidTextures = [
  Option('very_watery', 'Very watery'),
  Option('watery', 'Watery'),
  Option('thin', 'Thin'),
  Option('liquid', 'Liquid'),
  Option('creamy', 'Creamy'),
  Option('mucous_like', 'Mucous-like'),
  Option('slippery', 'Slippery'),
  Option('stretchy', 'Stretchy'),
  Option('stringy', 'Stringy'),
  Option('gel_like', 'Gel-like'),
  Option('thick', 'Thick'),
  Option('sludgy', 'Sludgy'),
  Option('grainy', 'Grainy'),
  Option('particulate', 'Particulate'),
  Option('clumpy', 'Clumpy'),
  Option('clotted', 'Clotted'),
  Option('tissue_like', 'Tissue-like'),
  Option('other', 'Other'),
];

const bloodPresenceOptions = [
  Option('definite', 'Definitely blood'),
  Option('possible', 'Possibly blood'),
  Option('not_observed', 'No blood observed'),
  Option('unknown', "I don't know"),
];

const odourOptions = [
  Option('no_change', 'No noticeable change'),
  Option('stronger', 'Stronger than usual'),
  Option('unusual', 'Unusual'),
  Option('unpleasant', 'Unpleasant'),
  Option('unsure', 'Unsure'),
];

const clotPresenceOptions = [
  Option('possible', 'Possibly a clot'),
  Option('definite', 'Definitely a clot'),
];

const clotQuantities = [
  Option('one', 'One'),
  Option('few', 'A few'),
  Option('several', 'Several'),
  Option('many', 'Many'),
];

const clotSizes = [
  Option('under_5mm', 'Under 5 mm'),
  Option('5_to_10mm', '5–10 mm'),
  Option('10_to_20mm', '10–20 mm'),
  Option('20_to_30mm', '20–30 mm'),
  Option('30_to_50mm', '30–50 mm'),
  Option('over_50mm', 'Over 50 mm'),
  Option('unknown', 'Not sure'),
];

const clotAppearances = [
  Option('red', 'Red'),
  Option('dark_red', 'Dark red'),
  Option('brown', 'Brown'),
  Option('gelatinous', 'Gelatinous'),
  Option('stringy', 'Stringy'),
  Option('tissue_like', 'Tissue-like'),
  Option('unsure', 'Unsure'),
  Option('other', 'Other'),
];

const libidoDirections = [
  Option('unusually_high', 'Unusually high libido'),
  Option('unusually_low', 'Unusually low libido'),
  Option('uncertain', 'Hard to describe / unsure'),
];

const moodCategories = [
  Option('low_sad', 'Low / sad'),
  Option('irritable_angry', 'Irritable / angry'),
  Option('anxious_tense', 'Anxious / tense'),
  Option('tearful_sensitive', 'Tearful / emotionally sensitive'),
  Option('energetic_activated', 'Energetic / activated'),
  Option('social_affectionate', 'Social / affectionate'),
  Option('emotionally_labile', 'Emotionally all over the place'),
  Option('other', 'Other'),
];

const physicalSymptomTypes = [
  Option('cramps', 'Cramps'),
  Option('pelvic_pain', 'Pelvic pain'),
  Option('back_pain', 'Back pain'),
  Option('breast_tenderness', 'Breast tenderness'),
  Option('bloating', 'Bloating'),
  Option('headache', 'Headache'),
  Option('nausea', 'Nausea'),
  Option('digestive_change', 'Digestive change'),
  Option('fatigue', 'Fatigue'),
  Option('dizziness', 'Dizziness'),
  Option('skin_change', 'Acne / skin change'),
  Option('other', 'Other'),
];

/// Symptom types for which pain details (severity/location/quality) apply.
const painSymptomKeys = {
  'cramps',
  'pelvic_pain',
  'back_pain',
  'headache',
};

const painLocations = [
  Option('lower_abdomen', 'Lower abdomen'),
  Option('left_pelvis', 'Left pelvis'),
  Option('right_pelvis', 'Right pelvis'),
  Option('lower_back', 'Lower back'),
  Option('general_abdominal', 'General abdominal'),
  Option('vaginal_vulval', 'Vaginal / vulval'),
  Option('other', 'Other'),
];

const painQualities = [
  Option('cramping', 'Cramping'),
  Option('aching', 'Aching'),
  Option('sharp', 'Sharp'),
  Option('stabbing', 'Stabbing'),
  Option('pressure', 'Pressure'),
  Option('burning', 'Burning'),
  Option('throbbing', 'Throbbing'),
  Option('other', 'Other'),
];

const contextEventTypes = [
  Option('contraception_started', 'Contraception started'),
  Option('contraception_stopped', 'Contraception stopped'),
  Option('contraception_changed', 'Contraception changed'),
  Option('iud_inserted', 'IUD inserted'),
  Option('iud_removed', 'IUD removed'),
  Option('medication_started', 'Medication started'),
  Option('medication_stopped', 'Medication stopped'),
  Option('medication_changed', 'Medication changed'),
  Option('pregnancy_test', 'Pregnancy test'),
  Option('medical_procedure', 'Medical procedure'),
  Option('illness', 'Illness'),
  Option('other', 'Other'),
];

const datePrecisions = [
  Option('exact', 'Exact date'),
  Option('approximate', 'Approximate date'),
  Option('range', 'Date range'),
  Option('month_only', 'Month only'),
];

const episodeInterpretations = [
  Option('possible_menstrual', 'Possible menstrual episode'),
  Option('probable_menstrual', 'Probable menstrual episode'),
  Option('confirmed_menstrual', 'Confirmed menstrual episode'),
  Option('other_bleeding', 'Possible non-menstrual bleeding'),
  Option('uncertain', 'Uncertain'),
];
