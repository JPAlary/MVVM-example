# MVVM Example

This project is a simple example of MVVM and network foundation on iOS using:
- RxSwift for asynchronous tasks and binding between view model and view
- Swinject for dependency injection
- SnapKit for UI constraint management

# Specificities

- ViewController acts like a bridge between View and ViewModel. It's not a view but holds instances of subviews.
- ViewModel formats data from Model objects. It exposes `Driver` of primitive type (Int, String, Double, etc..) which are binded to UI elements.
- View holds view model instance and do the binding between its UI elements and the `Driver` exposed by the View Model.
- Model are the part for all dependencies which manipulates data, business objects, use third party like network, etc...
- Model are abstract by protocol and are always injected in the View Model.
- About folders hierarchy:
	- Foundation contains all transversed extensions/dependencies.
	- Feature contains ViewController/View/ViewModel for each feature of the app.
