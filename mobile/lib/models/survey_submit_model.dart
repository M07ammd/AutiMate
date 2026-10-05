class SurveySubmitModel {
  final String childId;
  final List<int> scores;

  SurveySubmitModel({required this.childId, required this.scores});

  Map<String, dynamic> toJson() {
    return {
      "childId": childId,
      "A1_Score": scores[0],
      "A2_Score": scores[1],
      "A3_Score": scores[2],
      "A4_Score": scores[3],
      "A5_Score": scores[4],
      "A6_Score": scores[5],
      "A7_Score": scores[6],
      "A8_Score": scores[7],
      "A9_Score": scores[8],
      "A10_Score": scores[9],
    };
  }
}
