
enum APIFunction : String
{
    case getNearCurrents = "/api/parkings/getNearCurrents" //POST
    case parkings = "/api/parkings" //POST
    case login = "/api/users/login" //POST
    case register = "/api/users/register" //POST
    case getlistParkByUser = "/api/parkings/users" //POST
    case registerDeviceToken = "/api/registerDeviceToken" //POST
    case pushNotificationSingle = "/api/pushNotificationSingle" //POST
    case deleteDeviceToken = "/api/deleteDeviceToken" //POST

    case test2 = "123"
}
extension Services
{
    
}


