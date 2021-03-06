import QtQuick 2.0
import Felgo 3.0

App {

  NavigationStack {
    FlickablePage {
      title: "Firebase Storage"
      flickable.contentHeight: column.height

      FirebaseStorage {
        id: storage

        config: FirebaseConfig {
          projectId: "v-play-live-client-test-db"
          databaseUrl: "https://v-play-live-client-test-db.firebaseio.com"
          storageBucket: "v-play-live-client-test-db.appspot.com"

          //platform dependent - get these values from the google-services.json / GoogleService-info.plist
          apiKey: Qt.platform.os === "android" ? "AIzaSyD3Pmw89NHhdG9nGIQWwaOB55FuWjcDSS8" : "AIzaSyCheT6ZNFI4mUwfrPRB098a08dVzlhZNME"
          applicationId: Qt.platform.os === "android" ? "1:40083798422:android:ed7cffdd1548a7fa"  : "1:40083798422:ios:ed7cffdd1548a7fa"
        }
      }

      Column {
        id: column
        width: parent.width
        anchors.margins: dp(12)

        AppButton {
          text: "Capture image + upload"
          onClicked: nativeUtils.displayCameraPicker()
        }

        AppText {
          id: status
          text: "Idle"
        }

        // this will display the image after it's uploaded
        AppImage {
          id: img
          width: parent.width
          fillMode: AppImage.PreserveAspectFit
          autoTransform: true
        }
      }
    }
  }

  Connections {
    target: nativeUtils
    onCameraPickerFinished: {
      if(accepted) {
        //picture taken with camera is stored at path - upload to Firebase Storage
        storage.uploadFile(path, "test-image" + Date.now() + ".png", function(progress, finished, success, downloadUrl) {
          if(!finished) {
            status.text = "Uploading... " + progress.toFixed(2) + "%"
          } else if(success) {
            img.source = downloadUrl
            status.text = "Upload completed."
          } else {
            status.text = "Upload failed."
          }
        })
      }
    }
  }
}
