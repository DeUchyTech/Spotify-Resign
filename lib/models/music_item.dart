import 'package:flutter/material.dart';

class MusicItem {
  final String title;
  final String subtitle;
  final String image;
  final Color color;
  final int songCount;
  final bool isArtist;
  final String lyrics;
  final String duration;
  final String artistImage;
  final String monthlyListeners;

  const MusicItem(
      this.title,
      this.subtitle,
      this.image,
      this.color, {
        this.songCount = 0,
        this.isArtist = false,
        this.lyrics = '',
        this.duration = '3:40',
        this.artistImage = '',
        this.monthlyListeners = '',
      });

  MusicItem copyWith({
    String? title,
    String? subtitle,
    String? image,
    Color? color,
    int? songCount,
    bool? isArtist,
    String? lyrics,
    String? duration,
    String? artistImage,
    String? monthlyListeners,
  }) {
    return MusicItem(
      title ?? this.title,
      subtitle ?? this.subtitle,
      image ?? this.image,
      color ?? this.color,
      songCount: songCount ?? this.songCount,
      isArtist: isArtist ?? this.isArtist,
      lyrics: lyrics ?? this.lyrics,
      duration: duration ?? this.duration,
      artistImage: artistImage ?? this.artistImage,
      monthlyListeners: monthlyListeners ?? this.monthlyListeners,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'color': color.value,
      'songCount': songCount,
      'isArtist': isArtist,
      'lyrics': lyrics,
      'duration': duration,
      'artistImage': artistImage,
      'monthlyListeners': monthlyListeners,
    };
  }

  factory MusicItem.fromJson(Map<String, dynamic> json) {
    return MusicItem(
      json['title'] as String? ?? '',
      json['subtitle'] as String? ?? '',
      json['image'] as String? ?? '',
      Color(json['color'] as int? ?? 0xFF6750A4),
      songCount: json['songCount'] as int? ?? 0,
      isArtist: json['isArtist'] as bool? ?? false,
      lyrics: json['lyrics'] as String? ?? '',
      duration: json['duration'] as String? ?? '3:40',
      artistImage: json['artistImage'] as String? ?? '',
      monthlyListeners: json['monthlyListeners'] as String? ?? '',
    );
  }
}
