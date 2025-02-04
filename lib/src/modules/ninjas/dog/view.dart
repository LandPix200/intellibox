import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intellibox_v2/src/modules/apis/ninja.dart';

import 'model.dart';

class DogView extends StatelessWidget {
  const DogView({super.key, required this.dog});
  final Dog dog;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(dog.imageLink),
          const SizedBox(height: 10),
          Text(
            dog.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          _buildProgress(
              "Compatibilité avec les enfants", dog.goodWithChildren),
          _buildProgress(
              "Compatibilité avec les autres chiens", dog.goodWithOtherDogs),
          _buildProgress("Perte des poils/cheveux/plumes", dog.shedding),
          _buildProgress("Harcèlement", dog.grooming),
          _buildProgress("Bavage", dog.drooling),
          _buildProgress("Longueur du pelage", dog.coatLength),
          _buildProgress(
              "Comportement envers les étrangers", dog.goodWithStrangers),
          _buildProgress("Jouabilité", dog.playfulness),
          _buildProgress("Protection", dog.protectiveness),
          _buildProgress("Facilité de dressage", dog.trainability),
          _buildProgress("Niveau d'énergie", dog.energy),
          _buildProgress("Aboiement", dog.barking),
          _buildProgress("Durée de vie minimale", dog.minLifeExpectancy),
          _buildProgress("Durée de vie maximale", dog.maxLifeExpectancy),
          _buildProgress("Hauteur maximale (mâle)", dog.maxHeightMale),
          _buildProgress("Hauteur maximale (femelle)", dog.maxHeightFemale),
          _buildProgress("Poids maximal (mâle)", dog.maxWeightMale),
          _buildProgress("Poids maximal (femelle)", dog.maxWeightFemale),
        ],
      ),
    );
  }

  Widget _buildProgress(String title, double percent) {
    return CircularProgressIndicator.adaptive(
      value: percent / 100,
    );
  }
}

class DogPage extends StatefulWidget {
  const DogPage({super.key});

  @override
  State<DogPage> createState() => _DogPageState();
}

class _DogPageState extends State<DogPage> {
  Dog? dog;
  final _searchController = TextEditingController(text: "dog");
  Future<List<Dog>?>? _getDog;
  List<Dog>? dogList;

  @override
  void initState() {
    _getDog = Ninja.getDog(_searchController.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSearchField(),
          ),
          if (dogList != null && dogList!.isNotEmpty)
            SizedBox(
              height: 60,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _refreshDog(dogList![index].name);
                            dogList?.clear();
                          });
                        },
                        child: Chip(
                          label: Text(dogList![index].name),
                        ),
                      ),
                    );
                  },
                  itemCount: dogList!.length),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: _getDog,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      (snapshot.data == null || snapshot.data!.isEmpty)) {
                    return const Center(child: Text("Aucun chien trouvé"));
                  }

                  if (snapshot.hasData && snapshot.data != null) {
                    dog = snapshot.data![0];
                    return DogView(dog: dog!);
                  }

                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  CupertinoSearchTextField _buildSearchField() {
    return CupertinoSearchTextField(
      controller: _searchController,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      placeholder: "Rechercher un chien",
      prefixIcon: const Icon(Icons.search),
      suffixIcon: const Icon(Icons.send),
      onSuffixTap: (() => {
            setState(() {
              _refreshDog(_searchController.text);
              dogList?.clear();
            })
          }),
      style: const TextStyle(color: Colors.white),
      onSubmitted: (value) {
        _refreshDog(value);
      },
      // onChanged: (value) {
      // Ninja.getDog(value).then((value) {
      //   setState(() {
      //     dogList = value;
      //   });
      // });
      // },
    );
  }

  void _refreshDog(String value) {
    setState(() {
      _getDog = Ninja.getDog(_searchController.text);
    });
  }
}

class SearchResponse extends StatelessWidget {
  const SearchResponse({
    super.key,
    required this.dogs,
  });

  final List<Dog> dogs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resultats de recherche"),
      ),
    );
  }
}
