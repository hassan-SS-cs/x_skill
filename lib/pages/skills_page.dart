import 'package:flutter/material.dart';
import 'package:x_skill/models/skill_model.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  List<SkillModel> _skills = [];
  Map<String, List<SkillModel>> _grouped = {};

  Future<void> _loadData() async {
    final jsonStr = await rootBundle.loadString('assets/data/skills.json');
    final List data = json.decode(jsonStr);
    setState(() {
      _skills = data.map((e) => SkillModel.fromJson(e)).toList();
      for (var skill in _skills) {
        if (_grouped[skill.type] == null) {
          _grouped[skill.type] = [];
        }
        _grouped[skill.type]!.add(skill);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: _grouped.entries
            .expand(
              (entry) => [
                Container(
                  color: const Color.fromARGB(255, 91, 91, 91),
                  padding: EdgeInsets.all(8),
                  child: Text(entry.key,style: TextStyle(color: Colors.white),),
                ),
                ...entry.value.map(
                  (skill) => ListTile(
                    onTap: () {
                      final skillsInType = _grouped[skill.type]!;
                      int currentIndex = skillsInType.indexOf(skill);
                      showDialog(
                        context: context,
                        builder: (context) => StatefulBuilder(
                          builder: (context, setStateDialog) => Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),
                                Image.asset(skillsInType[currentIndex].image),
                                SizedBox(height: 20,),
                                  Text(skillsInType[currentIndex].name),
                                  SizedBox(height: 30,),
                                  SelectableText(
                                    skillsInType[currentIndex].description,
                                  ),
                                  if (currentIndex < skillsInType.length - 1)...[
                                  SizedBox(height: 30,),
                                    ElevatedButton(
                                      onPressed: () {
                                        setStateDialog(() => currentIndex++);
                                      },
                                      child: Text('Next'),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    title: Text(skill.name),
                  ),
                ),
              ],
            )
            .toList(),
      ),
    );
  }
}
