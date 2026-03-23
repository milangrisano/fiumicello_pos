class InfoTakeaway {
  final String id;
  final String time;
  final String name;
  final String status;

  InfoTakeaway(
      {required this.id,
      required this.time,
      required this.name,
      required this.status});
}

List<InfoTakeaway> takeawayContent = [
  InfoTakeaway(
    id: "710092021",
    time: "4:30 PM",
    name: "Marrika Cocino",
    status: "Selected",
  ),
  InfoTakeaway(
    id: "710092074",
    time: "4:45 PM",
    name: "Gnocchi alla Torrentina",
    status: "Cooking",
  ),
  InfoTakeaway(
    id: "710092025",
    time: "5:00 PM",
    name: "Brasab Bazolo",
    status: "Ready",
  ),
];
