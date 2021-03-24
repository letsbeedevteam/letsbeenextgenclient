class TermsConditions {
  TermsConditions({
    this.header,
    this.data
  });

  String header;
  List<TermsConditionsData> data;
}


class TermsConditionsData {
  TermsConditionsData({
    this.title,
    this.contents
  });

  String title;
  List<String> contents;
}