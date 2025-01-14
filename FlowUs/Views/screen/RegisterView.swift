//
//  RegisterView.swift
//  FlowUs
//
//  Created by Lucas Goldner on 18.04.22.
//

import CountryPicker
import L10n_swift
import SwiftUI
import UIPilot

struct RegisterView: View {
    @StateObject var registerOO: RegisterOO = .init()
    @EnvironmentObject var pilot: UIPilot<AppRoute>

    private func navigateToVerify() {
        pilot.push(.Verify(code: ""))
    }

    var body: some View {
        RegisterViewScrollView(content: {
            BackBar()
            RegisterHeading()
                .frame(width: UIScreen.screenWidth, height: 60)
                .padding(.top, 12)
            RegisterUserInfoSection(nameInput: $registerOO.data.name,
                                    userNameInput: $registerOO.data.username,
                                    emailInput: $registerOO.data.email,
                                    countryInput: $registerOO.data.country)
            RegisterBirthInfo(date: $registerOO.data.birthday,
                              sex: $registerOO.data.sex)
            RegisterPassword(password: $registerOO.data.password,
                             repeatPassword: $registerOO.data.confirmPassword,
                             isPasswordShown: $registerOO.data.showPassword,
                             registerOO: registerOO)
                .frame(width: UIScreen.screenWidth)
            VStack {
                SecondaryButton(
                    action: navigateToVerify,
                    text: "register.step.one".l10n(),
                    shadowsEnabled: false)
                    .accessibilityIdentifier("Verify")
            }
            .padding(.top, 24)
            .padding(.bottom, 48)
        }).enableLightStatusBar()
    }
}

struct RegisterViewScrollView<Content: View>: View {
    @ViewBuilder var content: Content
    @State var verticalOffset: CGFloat = 0.0

    var body: some View {
        OffsettableScrollView { point in
            verticalOffset = point.y
        } content: {
            VStack {
                content
            }.padding(.top, UIDevice.current.hasNotch ? 48 : 24)
                .background(LinearGradient(gradient:
                    Gradient(
                        colors: [.init(hex: "0D6FCA"),
                                 .init(hex: "26006F"),
                                 .init(hex: "4B0384")]),
                    startPoint: .top,
                    endPoint: .bottom)
                    .frame(height: 1000))
        }
        .keyboardAware()
        .background(VStack(spacing: 0) {
            -verticalOffset / UIScreen.screenHeight >= 0.25 ?
                Color(hex: "4B0384") : Color(hex: "0D6FCA")
            Color(hex: "4B0384")
        }).ignoresSafeArea()
    }
}

struct RegisterHeading: View {
    var body: some View {
        ZStack {
            Icon(resize: true, path: "ScreenAssets/Register/Spring-1")
                .frame(width: 180, height: 180)
                .padding(.leading, 320)
            HeadingB(text: "register.creat.account".l10n())
                .foregroundStyle(.white)
        }
    }
}

struct RegisterUserInfoSection: View {
    @Binding var nameInput: String
    @Binding var userNameInput: String
    @Binding var emailInput: String
    @Binding var countryInput: Country?

    var body: some View {
        ZStack {
            Icon(resize: false, path: "ScreenAssets/Register/Explore")
                .padding(.leading, 10)
            TextInputTriple(inputFirst: $nameInput,
                            inputSecond: $userNameInput,
                            inputThird: $emailInput,
                            color: .white,
                            placeholderTextFirst: "register.real.name".l10n(),
                            placeholderTextSecond: "register.user.name".l10n(),
                            placeholderTextThird: "register.user.mail".l10n())
                .padding(.top, 328)
            Icon(resize: true, path: "ScreenAssets/Register/Spring-2")
                .frame(width: 160, height: 160)
                .padding(.trailing, 360)
                .padding(.top, 152)
                .frame(height: 150)
            CountryInput(country: $countryInput, width: 60, height: 28,
                         placeholderText: "register.country".l10n())
                .padding(.top, 328)
                .padding(.leading, 292)
                .frame(width: 60, height: 28).blur(radius: 10)
            CountryInput(country: $countryInput, width: 60, height: 28,
                         placeholderText: "register.country".l10n())
                .padding(.top, 328)
                .padding(.leading, 292)
                .frame(width: 60, height: 28)
        }.frame(width: UIScreen.screenWidth - 15)
            .padding(.top, -152)
    }
}

struct RegisterBirthInfo: View {
    @Binding var date: Date
    @Binding var sex: String

    var body: some View {
        HStack {
            CommonText(
                text: "register.mail.verify".l10n(),
                semibold: true)
                .foregroundColor(.white)
            Spacer()
        }
        .frame(width: UIScreen.screenWidth - 15)

        HStack {
            VStack {
                DateInput(date: $date,
                          width: UIScreen.screenWidth / 3.2,
                          height: 40,
                          placeholderText: "register.birthday".l10n())
                    .padding(.top, 52)
                Icon(resize: true, path: "ScreenAssets/Register/CurvyLine")
                    .frame(width: 180, height: 140)
            }
            SelectionInput(
                selectedItem: $sex,
                items: ["Male", "Female", "Other"],
                text: "Choose sex",
                color: .white)
                .padding(.trailing, 12)
        }
        .padding(.top, -16)
    }
}

struct RegisterPassword: View {
    @Binding var password: String
    @Binding var repeatPassword: String
    @Binding var isPasswordShown: Bool
    let registerOO: RegisterOO

    var body: some View {
        ZStack {
            SecureTextInputDouble(
                inputFirst: $password,
                inputSecond: $repeatPassword,
                showFirst: $isPasswordShown,
                showSecond: .constant(false),
                color: .white,
                placeholderTextFirst: "Password",
                placeholderTextSecond: "Repeat Password")

            HStack {
                Spacer()
                ShowPasswordButton(isShown: $isPasswordShown,
                                   action: registerOO.toogleViewPassword,
                                   shadowColor: .yellow,
                                   width: 32,
                                   height: 32)
                    .padding(.trailing, 16)
                    .padding(.top, -52)
            }.frame(width: UIScreen.screenWidth)
        }
    }
}

// struct RegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        DefaultPreview(content: RegisterView())
//    }
// }
