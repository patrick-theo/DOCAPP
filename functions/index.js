const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()
exports.sendNotification = functions.firestore
    .document('notifications/{groupID1}/{groupID2}/{message}')
    .onCreate((snap, context) => {
        console.log('----------------start function--------------------')

        const doc = snap.data()
        console.log(doc)
        const idFrom = doc.idFrom
        const idTo1 = doc.idTo1
        const idTo2 = doc.idTo2
        const contentMessage = doc.content


        admin
            .firestore()
            .collection('Doctors')
            .where('Npi', '==', idTo1)
            .get()
            .then(querySnapshot => {
                querySnapshot.forEach(userTo => {
                    console.log(`Found user to: ${userTo.data().Nickname}`)
                    if (userTo.data().pushToken) {
                        // Get info user from (sent)
                        admin
                            .firestore()
                            .collection('Doctors')
                            .where('Npi', '==', idFrom)
                            .get()
                            .then(querySnapshot2 => {
                                querySnapshot2.forEach(userFrom => {
                                    console.log(`Found user from: ${userFrom.data().Nickname}`)
                                    const payload = {
                                        notification: {
                                            title: "New Patient",
                                            body: `You have a Patient from "${userFrom.data().Nickname}"`,
                                            badge: '1',
                                            sound: 'default'
                                        }
                                    }
                                    // Let push to the target device
                                    admin
                                        .messaging()
                                        .sendToDevice(userTo.data().pushToken, payload)
                                        .then(response => {
                                            console.log('Successfully sent message:', response)
                                        })
                                        .catch(error => {
                                            console.log('Error sending message:', error)
                                        })
                                })
                            })
                    } else {
                        console.log('Can not find pushToken target user1')
                    }
                })
            })
        admin
            .firestore()
            .collection('Patients')
            .where('id', '==', idTo2)
            .get()
            .then(querySnapshot => {
                querySnapshot.forEach(userTo => {
                    console.log(`Found user to: ${userTo.data().name}`)
                    if (userTo.data().pushToken) {
                        // Get info user from (sent)
                        admin
                            .firestore()
                            .collection('Doctors')
                            .where('Npi', '==', idFrom)
                            .get()
                            .then(querySnapshot3 => {
                                querySnapshot3.forEach(userFrom => {
                                    console.log(`Found user from: ${userFrom.data().Nickname}`)
                                    const payload = {
                                        notification: {
                                            title: `New Recommendation"`,
                                            body: `You have been recommended to "${userFrom.data().Nickname}"`,
                                            badge: '1',
                                            sound: 'default'
                                        }
                                    }
                                    // Let push to the target device
                                    admin
                                        .messaging()
                                        .sendToDevice(userTo.data().pushToken, payload)
                                        .then(response => {
                                            console.log('Successfully sent message:', response)
                                        })
                                        .catch(error => {
                                            console.log('Error sending message:', error)
                                        })
                                })
                            })
                    } else {
                        console.log('Can not find pushToken target user2')
                    }
                })
            })
        return null
    })
exports.sendNotification1 = functions.firestore
    .document('appointment/{groupID1}/{groupID2}/{message}')
    .onCreate((snap, context) => {
        console.log('----------------start function--------------------')

        const doc = snap.data()
        console.log(doc)
        const idFrom = doc.idFrom
        const idTo = doc.idTo

        const contentMessage = doc.content


        admin
            .firestore()
            .collection('Patients')
            .where('id', '==', idTo)
            .get()
            .then(querySnapshot => {
                querySnapshot.forEach(userTo => {
                    console.log(`Found user to: ${userTo.data().name}`)
                    if (userTo.data().pushToken) {

                        admin
                            .firestore()
                            .collection('Doctors')
                            .where('Npi', '==', idFrom)
                            .get()
                            .then(querySnapshot2 => {
                                querySnapshot2.forEach(userFrom => {
                                    console.log(`Found user from: ${userFrom.data().Nickname}`)
                                    const payload = {
                                        notification: {
                                            title: `New Appointment`,
                                            body: `You have an Appointment with "${userFrom.data().Nickname}"`,
                                            badge: '1',
                                            sound: 'default'
                                        }
                                    }

                                    admin
                                        .messaging()
                                        .sendToDevice(userTo.data().pushToken, payload)
                                        .then(response => {
                                            console.log('Successfully sent message:', response)
                                        })
                                        .catch(error => {
                                            console.log('Error sending message:', error)
                                        })
                                })
                            })
                    } else {
                        console.log('Can not find pushToken target user1')
                    }
                })
            })

        return null
    })