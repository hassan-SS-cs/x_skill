import 'package:flutter/material.dart';
import 'package:x_skill/models/photos_model.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:photo_view/photo_view.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  List<PhotosModel> _allPhotos = [];
  int _currentPage = 1;
  TapDownDetails? _tapDetails;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // returns only photos that belong to the current page
  List<PhotosModel> get _currentPhotos {
    return _allPhotos.where((photo) => photo.page == _currentPage).toList();
  }

  // finds the highest page number from all photos
  int get _totalPages {
    if (_allPhotos.isEmpty) return 1;
    return _allPhotos.map((p) => p.page).reduce((a, b) => a > b ? a : b);
  }

  // loads photos from local JSON file and stores them in _allPhotos
  Future<void> _loadData() async {
    final jsontStr = await rootBundle.loadString('assets/data/photos.json');
    final List data = json.decode(jsontStr);
    setState(() {
      _allPhotos = data.map((item) => PhotosModel.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Photos grid
          SizedBox(height: 100,),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _currentPhotos.length,
              itemBuilder: (context, index) {
                final photo = _currentPhotos[index];
                return GestureDetector(
                  // saves tap position to use it for the context menu location
                  onTapDown: (details) => _tapDetails = details,
                  // opens photo in fullscreen with zoom support
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          backgroundColor: Colors.black,
                          appBar: AppBar(
                            backgroundColor: Colors.black,
                            iconTheme: IconThemeData(color: Colors.white),
                          ),
                          body: PhotoView(
                            imageProvider: NetworkImage(photo.url),
                          ),
                        ),
                      ),
                    );
                  },
                  // shows context menu at tap position with share option
                  onLongPress: () {
                    final position = RelativeRect.fromLTRB(
                      _tapDetails!.globalPosition.dx,
                      _tapDetails!.globalPosition.dy,
                      _tapDetails!.globalPosition.dx,
                      _tapDetails!.globalPosition.dy,
                    );
                    showMenu(
                      context: context,
                      position: position,
                      items: [
                        PopupMenuItem(
                          value: 'share',
                          child: Text('Share this photo'),
                        ),
                      ],
                    ).then((value) {
                      if (value == 'share') {
                        SharePlus.instance.share(ShareParams(text: photo.url));
                      }
                    });
                  },
                  child: Container(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            photo.url,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(child: Icon(Icons.error));
                            },
                          ),
                        ),
                        // popularity and visit overlay at bottom of photo
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black54,
                            padding: EdgeInsets.all(4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Popularity: ${photo.popularity}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  'Visit: ${photo.visit}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Pagination bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_totalPages, (index) {
                final page = index + 1;
                final isSelected = page == _currentPage;
                return GestureDetector(
                  // changes current page on tap and rebuilds the grid
                  onTap: () => setState(() => _currentPage = page),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$page',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}