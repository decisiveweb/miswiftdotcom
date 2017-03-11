import Vapor

let drop = Droplet()

// Meetup Header Info

// Get the next meetup from the meetup.com API
    let meetupResponse = try drop.client.get("https://api.meetup.com/mi-swift/events?photo-host=public&page=1&sig_id=92233812")
    // Initialize variables
    var attendees: Int? // The number of attendees who have RSVP'd Yes
    var link, name: String? // A URL to the event page and the title of the event
    if let response = try JSON(bytes: meetupResponse.body.bytes!)[0] {
        attendees = response["yes_rsvp_count"]?.node.int
        link = response["link"]?.string
        name = response["name"]?.string
    }




drop.get ("/") { req in
    if let attendees = attendees, let link = link, let name = name {
        // If we have data from the API, pass it to the template
        return try drop.view.make("index", Node(node: ["attendees": "\(attendees)", "link": "\(link)", "name": "\(name)"]))
    } else {
        return try drop.view.make("index")
    }
}

drop.get ("/about") { req in
    if let attendees = attendees, let link = link, let name = name {
        // If we have data from the API, pass it to the template
        return try drop.view.make("about", Node(node: ["attendees": "\(attendees)", "link": "\(link)", "name": "\(name)"]))
    } else {
        return try drop.view.make("about")
    }
}



drop.run()
