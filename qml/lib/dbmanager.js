/*
 * Utility functions to acces Local Storage
 */

.import QtQuick.LocalStorage 2.0 as LS

function getDB() {
    var db;

    try {
        db = LS.LocalStorage.openDatabaseSync("CentoDB", "1.0", "Cento High Scores", 1000000);
        db.transaction(
           function(tx) {
               // Create high scores table if it doesn't already exist
               tx.executeSql('CREATE TABLE IF NOT EXISTS hiscore(date DATE, score INT)');
           }
        );
    } catch (error) {
        console.log(error);
    }

    return db;
}

function saveHighScore(score) {
    var db = getDB();

    if (typeof db == "object") {
        try {
            db.transaction(
                function(tx) {
                    // Insert current score
                    tx.executeSql('INSERT INTO hiscore VALUES (date(\'now\'), ?)', [ score ]);
                }
            );
        } catch (error) {
            console.log(error);
        }
    }
}

function getHighScores(limit) {
    var db = getDB();
    var hs = [];

    if (typeof db == "object") {
        try {
            db.readTransaction(
                function(tx) {
                    // Get (top) high scores
                    var rs = tx.executeSql('SELECT score,count(*) as num,max(date) as last FROM hiscore group by score order by score desc' + ((limit > 0) ? (' limit ' + limit) : ''));
                    for(var i = 0; i < rs.rows.length; i++) {
                        hs.push({ "pos": (i + 1), "score": rs.rows.item(i).score, "num": rs.rows.item(i).num, "last": rs.rows.item(i).last });
                    }
                }
            );
        } catch (error) {
            console.log(error);
        }
    }

    return hs;
}
