
import 'package:beamsbistro/Controllers/Services/appExceptions.dart';
import 'package:oktoast/oktoast.dart';

mixin BaseController {
  void handleError(error) {
    if (error is BadRequestException) {
      var message = error.message;
      //showToast( message.toString());

    } else if (error is FetchDataException) {
      var message = error.message;
     showToast( message.toString());


    } else if (error is ApiNotRespondingException) {
      var message = error.message;
      showToast( message.toString());
    }
  }
}