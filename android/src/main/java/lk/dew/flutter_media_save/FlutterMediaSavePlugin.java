package lk.dew.flutter_media_save;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;

import androidx.annotation.NonNull;

import java.io.OutputStream;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterMediaSavePlugin */
public class FlutterMediaSavePlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_media_save");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success(Build.VERSION.SDK_INT);
    }else if (call.method.equals("saveFile")) {
      final Map<String, Object> args = call.arguments();
      final byte[] bytes = (byte[]) args.get("bytes");
      final String mimeType = Objects.requireNonNull(args.get("mimeType")).toString();
      String extension = null;
      if (mimeType.equals("image/png")) extension = ".png";
      else extension = ".jpeg";

      String name = null;
      if (args.get("name") != null) name = args.get("name").toString();
      else name = UUID.nameUUIDFromBytes(bytes).toString();
      Bitmap bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.length);

      result.success(saveFile(name, bitmap, extension, mimeType));
    } else {
      result.notImplemented();
    }
  }


  private boolean saveFile(String name, Bitmap bitmap, String extension, String mimeType) {
    Uri imageCollection = null;
    ContentResolver resolver = context.getContentResolver();
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
      imageCollection = MediaStore.Images.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY);
    } else {
      imageCollection = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
    }

    ContentValues contentValues = new ContentValues();
    contentValues.put(MediaStore.Images.Media.DISPLAY_NAME, name + extension);
    contentValues.put(MediaStore.Images.Media.MIME_TYPE, mimeType);
    Uri imageUri = resolver.insert(imageCollection, contentValues);

    try {
      OutputStream outputStream = resolver.openOutputStream(Objects.requireNonNull(imageUri));
      Bitmap.CompressFormat compressFormat = Bitmap.CompressFormat.PNG;
      if(extension.equals(".jpeg")){
        compressFormat = Bitmap.CompressFormat.JPEG;
      }
      Log.d("TAG", compressFormat.toString());

      bitmap.compress(compressFormat, 100, outputStream);
      Objects.requireNonNull(outputStream).close();
      return true;
    } catch (Exception e) {
      Log.d("SAVE", "saveFile: " + e.getLocalizedMessage());
      return false;
    }
  }


  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
