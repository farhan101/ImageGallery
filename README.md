# Swift Media Gallery With Zoom and Pan Images and Streaming Videos

Media gallery supports **Images** and **Videos**. Images can be provided as url string or UIImage object. For now, only streaming video is supported. Video thumbnails can be paseed as url string or UIImage object.

### How to Install
Download the sample project and pick the following files to add to your project

1. IndexedButton.swift
2. ImageScrollView.swift
3. MediaGallery.swift
4. MediaGallery.xib

### Implement the Delegate ImageGalleryDelegate
```
  func imageGallery(completion: @escaping ([MediaBase]?) -> Void) {
        var collection:[MediaBase] = []
        //1. Pass Image as url string
        var data = ImageRecord<String>()
        data.media = images[0]
        collection.append(data)
        //2. Pass Image as UIImage object
        var data1_1 = ImageRecord<UIImage>()
        data1_1.media = UIImage(named: "k2")
        collection.append(data1_1)
        //3. Pass video thumbnail as url string
        var data2 = VideoRecord<String, String>()
        data2.media = "https://www.radiantmediaplayer.com/media/bbb-360p.mp4"
        data2.thumbnail = images[1]
        collection.append(data2)
        completion(collection)
        //4. Pass video thumbnail as UIImage object
        var data2_1 = VideoRecord<String, UIImage>()
        data2_1.media = "https://www.radiantmediaplayer.com/media/bbb-360p.mp4"
        data2_1.thumbnail = UIImage(named: "bunny")
        collection.append(data2_1)
        completion(collection)
    }
```

### How to launch gallery
*e.g. place this code inside button's action*
```
        let gallery = MediaGallery()
        gallery.delegate = self
        gallery.topTitle = "Media Gallery"
        gallery.modalTransitionStyle = .crossDissolve
        self.present(gallery, animated: true, completion: nil)
```


![Image](https://github.com/farhan101/ImageGallery/blob/master/swift_image_gallery_1.jpg)

![Video](https://github.com/farhan101/ImageGallery/blob/master/swift_image_gallery_2.jpg)
