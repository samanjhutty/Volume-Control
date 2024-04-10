class ScenarioDay {
  ScenarioDay({required this.day, required this.selected});
  String day;
  bool selected;
}

List<ScenarioDay> dayList = [
  ScenarioDay(day: 'Mon', selected: false),
  ScenarioDay(day: 'Tue', selected: false),
  ScenarioDay(day: 'Wed', selected: false),
  ScenarioDay(day: 'Thu', selected: false),
  ScenarioDay(day: 'Fri', selected: false),
  ScenarioDay(day: 'Sat', selected: false),
  ScenarioDay(day: 'Sun', selected: false),
];
