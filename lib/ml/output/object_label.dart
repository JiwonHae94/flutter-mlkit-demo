class Label{
  final double confidence;
  final int index;
  final String text;

  Label({required this.index, required this.confidence, required this.text});


  factory Label.fromJson(Map<dynamic, dynamic> json) => Label(
    index: json['index'],
    text: json['text'],
    confidence: json['confidence']
  );
}