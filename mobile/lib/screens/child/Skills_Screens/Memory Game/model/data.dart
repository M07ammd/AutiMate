import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

List<String> getMasterImagePool() {
  return [
    'assets/images/cat.png',
    'assets/images/duck.png',
    'assets/images/goat.png',
    'assets/images/horse.png',
    'assets/images/lion.png',
    'assets/images/monkey.png',
    'assets/images/mouse.png',
    'assets/images/rabbit.png',
    'assets/images/Sheep.png'
  ];
}

List<String> imageSource(int pairCount) {
  final pool = getMasterImagePool();
  pool.shuffle(); // Randomize selection
  
  // Pick 'pairCount' unique images
  final selected = pool.take(pairCount).toList();
  
  // Duplicate them to form pairs
  final result = <String>[];
  for (var img in selected) {
    result.add(img);
    result.add(img);
  }
  return result;
}

List<String> createShuffledListFromImageSource(int pairCount) {
  final List<String> shuffledImages = [];
  shuffledImages.addAll(imageSource(pairCount));
  shuffledImages.shuffle();
  return shuffledImages;
}

List<bool> getInitialItemStateList(int totalCards) {
  return List<bool>.filled(totalCards, true);
}

List<GlobalKey<FlipCardState>> createFlipCardStateKeysList(int totalCards) {
  return List.generate(totalCards, (index) => GlobalKey<FlipCardState>());
}
