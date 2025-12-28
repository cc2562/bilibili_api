# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2025-12-28

### Added

#### Core Features
- **HTTP Client** with automatic Cookie management and WBI signature support
- **Cookie Manager** for handling Bilibili authentication cookies
- **WBI Signer** implementing Bilibili's WBI signature algorithm
- Generic API response wrapper and exception handling

#### Login Module
- QR code login flow with automatic polling
- Login information retrieval (navigation info and statistics)
- WBI keys refresh functionality
- Support for both authenticated and unauthenticated requests

#### User Module
- User detailed information query (WBI signed)
- User card information retrieval
- **User Relations**: Get followers and following lists with pagination
- **User Space**: Get user uploaded videos with search and filtering
  - Search within user's videos by keyword
  - Filter by category
  - Sort by publish date, views, or favorites
  - Automatic pagination support

#### Video Module
- Video information query by BVID or AID
- **Video Stream** URL retrieval supporting:
  - DASH format (separate video/audio streams)
  - MP4/FLV format
  - Multiple quality levels (360P to 4K)
  - Dolby audio support
- **Video Actions** (requires login):
  - Like/unlike videos
  - Coin videos (1 or 2 coins)
  - Favorite/unfavorite videos
  - Triple action (like + coin + favorite)

#### Search Module
- Comprehensive search across all content types
- Video search with advanced filtering:
  - Duration filters
  - Category filters
  - Multiple sort orders
- User search with ranking options
- Search suggestions with pinyin support

#### Dynamic Module (Simplified)
- Get dynamic feed (all or filtered by type)
- Get user space dynamics
- Get specific dynamic details
- Returns raw JSON for maximum flexibility
- Helper method to extract common fields

### Features

- **Type-Safe Models** for all API responses
- **Automatic WBI Signing** for protected endpoints
- **Pagination Support** with automatic page fetching
- **Error Handling** with BiliException
- **5 Complete Examples** demonstrating all features:
  - QR code login flow
  - User information queries
  - Video information and playback
  - Video stream URLs and actions
  - Search functionality

### Documentation

- Comprehensive README in English
- Detailed Chinese usage guide (使用文档.md)
- Complete API documentation in code comments
- Example code for all major features

### Technical Details

- Minimum Dart SDK: 3.9.2
- Flutter: >=1.17.0
- Dependencies:
  - `http: ^1.1.0` for HTTP requests
  - `crypto: ^3.0.3` for WBI signature MD5 calculation

### Notes

- Dynamic module uses simplified implementation returning raw JSON
- Cookie refresh API not implemented (not needed for Flutter apps)
- All APIs designed for Bilibili Web endpoints
- Based on [bilibili-API-collect](https://github.com/SocialSisterYi/bilibili-API-collect) documentation

---

## [Unreleased]

### Planned Features
- Live room APIs
- Danmaku (comments) APIs
- Advanced video features (subtitles, tags)
- User advanced statistics
- Full typed dynamic models (if needed)

[0.0.1]: https://github.com/yourusername/bilibili_api/releases/tag/v0.0.1
