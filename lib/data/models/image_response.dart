// To parse this JSON data, do
//
//     final imageResponse = imageResponseFromJson(jsonString);

import 'dart:convert';

ImageResponse imageResponseFromJson(String str) => ImageResponse.fromJson(json.decode(str));

String imageResponseToJson(ImageResponse data) => json.encode(data.toJson());

class ImageResponse {
    Data? data;
    bool? success;
    int? status;

    ImageResponse({
        this.data,
        this.success,
        this.status,
    });

    ImageResponse copyWith({
        Data? data,
        bool? success,
        int? status,
    }) => 
        ImageResponse(
            data: data ?? this.data,
            success: success ?? this.success,
            status: status ?? this.status,
        );

    factory ImageResponse.fromJson(Map<String, dynamic> json) => ImageResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        success: json["success"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "success": success,
        "status": status,
    };
}

class Data {
    String? id;
    String? title;
    String? urlViewer;
    String? url;
    String? displayUrl;
    int? width;
    int? height;
    int? size;
    int? time;
    int? expiration;
    Image? image;
    Image? thumb;
    String? deleteUrl;

    Data({
        this.id,
        this.title,
        this.urlViewer,
        this.url,
        this.displayUrl,
        this.width,
        this.height,
        this.size,
        this.time,
        this.expiration,
        this.image,
        this.thumb,
        this.deleteUrl,
    });

    Data copyWith({
        String? id,
        String? title,
        String? urlViewer,
        String? url,
        String? displayUrl,
        int? width,
        int? height,
        int? size,
        int? time,
        int? expiration,
        Image? image,
        Image? thumb,
        String? deleteUrl,
    }) => 
        Data(
            id: id ?? this.id,
            title: title ?? this.title,
            urlViewer: urlViewer ?? this.urlViewer,
            url: url ?? this.url,
            displayUrl: displayUrl ?? this.displayUrl,
            width: width ?? this.width,
            height: height ?? this.height,
            size: size ?? this.size,
            time: time ?? this.time,
            expiration: expiration ?? this.expiration,
            image: image ?? this.image,
            thumb: thumb ?? this.thumb,
            deleteUrl: deleteUrl ?? this.deleteUrl,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        urlViewer: json["url_viewer"],
        url: json["url"],
        displayUrl: json["display_url"],
        width: json["width"],
        height: json["height"],
        size: json["size"],
        time: json["time"],
        expiration: json["expiration"],
        image: json["image"] == null ? null : Image.fromJson(json["image"]),
        thumb: json["thumb"] == null ? null : Image.fromJson(json["thumb"]),
        deleteUrl: json["delete_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "url_viewer": urlViewer,
        "url": url,
        "display_url": displayUrl,
        "width": width,
        "height": height,
        "size": size,
        "time": time,
        "expiration": expiration,
        "image": image?.toJson(),
        "thumb": thumb?.toJson(),
        "delete_url": deleteUrl,
    };
}

class Image {
    String? filename;
    String? name;
    String? mime;
    String? extension;
    String? url;

    Image({
        this.filename,
        this.name,
        this.mime,
        this.extension,
        this.url,
    });

    Image copyWith({
        String? filename,
        String? name,
        String? mime,
        String? extension,
        String? url,
    }) => 
        Image(
            filename: filename ?? this.filename,
            name: name ?? this.name,
            mime: mime ?? this.mime,
            extension: extension ?? this.extension,
            url: url ?? this.url,
        );

    factory Image.fromJson(Map<String, dynamic> json) => Image(
        filename: json["filename"],
        name: json["name"],
        mime: json["mime"],
        extension: json["extension"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "filename": filename,
        "name": name,
        "mime": mime,
        "extension": extension,
        "url": url,
    };
}
