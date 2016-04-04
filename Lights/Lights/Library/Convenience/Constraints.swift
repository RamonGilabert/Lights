import UIKit

extension StartController {

  func setupConstraints() {
    NSLayoutConstraint.activateConstraints([
      startView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      startView.bottomAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: Dimensions.bottomOffset),

      flameView.heightAnchor.constraintEqualToConstant(Dimensions.flameHeight),
      flameView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      flameView.topAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: Dimensions.flameOffset),

      explanationView.topAnchor.constraintEqualToAnchor(flameView.bottomAnchor, constant: Dimensions.explanationOffset),
      explanationView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      explanationView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: Dimensions.explanationWidth),

      searchingLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 92),
      searchingLabel.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: Dimensions.searchingOffset)
      ])
  }
}

extension LightsController {

  func setupConstraints() {
    NSLayoutConstraint.activateConstraints([
      searchButton.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: Dimensions.buttonTopOffset),
      searchButton.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: Dimensions.buttonRightOffset),

      editingView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: Dimensions.wheelWidth),
      editingView.heightAnchor.constraintEqualToAnchor(editingView.widthAnchor),
      editingView.topAnchor.constraintEqualToAnchor(searchButton.bottomAnchor, constant: Dimensions.wheelOffset),
      editingView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),

      turnButton.widthAnchor.constraintEqualToConstant(DetailButton.Dimensions.buttonWidth),
      turnButton.heightAnchor.constraintEqualToConstant(DetailButton.Dimensions.buttonHeight),
      turnButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      turnButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: DetailButton.Dimensions.buttonOffset + 10)
      ])
  }
}

extension PairingController {

  func setupConstraints() {
    let width = UIScreen.mainScreen().bounds.width

    NSLayoutConstraint.activateConstraints([
      flameView.widthAnchor.constraintEqualToConstant(Dimensions.flameWidth),
      flameView.heightAnchor.constraintEqualToConstant(Dimensions.flameHeight),
      flameView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      flameView.bottomAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: Dimensions.flameOffset),

      titleLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      titleLabel.topAnchor.constraintEqualToAnchor(flameView.bottomAnchor, constant: Dimensions.titleOffset),

      pairingLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: width / 3 - 10),
      pairingLabel.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: Dimensions.pairingOffset),

      pairedView.widthAnchor.constraintEqualToAnchor(view.widthAnchor),
      pairedView.heightAnchor.constraintEqualToAnchor(view.heightAnchor),
      pairedView.topAnchor.constraintEqualToAnchor(view.topAnchor),
      pairedView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
      ])
  }
}
