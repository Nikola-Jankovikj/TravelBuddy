import SwiftUI

struct CreateProfileView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject private var viewModel = CreateProfileViewModel()
    @Binding public var showSignInView: Bool
    @State public var showRequestLocationView = false
    @Binding var email: String
    @Binding var password: String
    @State private var selectedActivity: Activity = .sightseeing  // Default

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        VStack(spacing: 25) {
            

            // Name Field
            TextField("Name", text: $viewModel.name)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )

            // Favorite Activity Picker
            VStack(alignment: .leading, spacing: 10) {
                Text("Favorite Activity")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)

                ForEach(Activity.allCases) { activity in
                    HStack {
                        Image(systemName: selectedActivity == activity ? "circle.fill" : "circle") // Use filled circle for selected
                            .foregroundColor(selectedActivity == activity ? .blue : .gray)
                            .onTapGesture {
                                selectedActivity = activity
                                viewModel.favoriteActivity = activity // Update selected activity
                            }

                        Text(activity.rawValue)
                            .onTapGesture {
                                selectedActivity = activity
                                viewModel.favoriteActivity = activity // Update selected activity on label tap
                            }
                    }
                    .padding(.vertical, 8)
                    .contentShape(Rectangle()) // Make the entire row tappable
                }
                
                // Optional: Add a divider for visual separation
                Divider()
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            // Description Field
            TextField("Description", text: $viewModel.description)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )
            
            TextField("Instagram", text: $viewModel.instagram)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )
            
            // Location Button
            Button(action: {
                if locationManager.userLocation == nil {
                    showRequestLocationView = true
                }
            }) {
                HStack {
                    Image(systemName: "location.fill")
                    Text("Get Location")
                }
                .font(.headline)
                .foregroundColor(.blue)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            }
            .sheet(isPresented: $showRequestLocationView) {
                LocationRequestView(showRequestLocationView: $showRequestLocationView)
            }

            // Age Stepper
            Stepper("\(viewModel.age) years old", value: $viewModel.age, in: 18...100)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )
            
            // Create Profile Button
            Button(action: {
                NotificationManager.instance.requestAuthorization()
                Task {
                    do {
                        try await viewModel.signUp(email: email, password: password)
                        try viewModel.createProfile()
                        showSignInView = false
                    } catch {
                        print("Error \(error)")
                    }
                }
            }) {
                Text("Create Profile")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 3)
            }
            .disabled(viewModel.instagram.isEmpty)

            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding()
        .navigationTitle("Create Profile")
    }
}

#Preview {
    CreateProfileView(showSignInView: .constant(true), email: .constant("test@mail.com"), password: .constant("Test123!"))
}
