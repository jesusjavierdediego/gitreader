package askgit


// Include the name/path of the file in commits.message field when the commit is done.

// Get history of a file as a list of commits
//EXAMPLE: askgit "SELECT DISTINCT(COMMIT_HASH) FROM blame ('','','100.json')"  --repo "/var/git/repos/TestRepository"
// PARAMS: 1-path+name of the file
const Query_commitlist_by_file = "SELECT DISTINCT(COMMIT_HASH) FROM blame ('','','%s')"
//const Query_commitlist_by_file = "SELECT DISTINCT hash FROM commits WHERE path = '%s'"

// NEXT PHASE
// We can only get commits from the table 'blame'. Past commitys woth no trace in the currenty record will be ignored. We need those commits.
// We'll insert the file path as the commit message.
// TODO: Change when the commit message is populated with the path+name of the file
//const Query_commitlist_by_file = "SELECT * FROM commits WHERE message LIKE '%s'"


// Get the content of the file in a specific commit. Iterate the list of file and find the 
// PARAMS:  1-Commit hash 2-File path including file extension (e.g. '100.json')
// Example: askgit "SELECT * FROM files ('','009ad0734ea8727e6a1064663a8b901ad5f47272') WHERE PATH='100.json'"  --repo "/var/git/repos/TestRepository"
// RETURN:  | PATH | EXECUTABLE | CONTENTS
const Query_contents_from_commit_in_file = "SELECT * FROM files ('','%s') WHERE PATH='%s'" 
//const Query_contents_from_commit_in_file = "SELECT contents FROM files WHERE commit_id = '%s' AND name = '%s'"


// Get the details of a given commit ID
// EXAMPLE: askgit "SELECT * FROM commits WHERE hash='6836a89827c310a3ae7e431fedba9ca62252e5be'" --repo "/var/git/repos/TestRepository"
// RETURN:  | HASH | MESSAGE | AUTHOR_NAME | AUTHOR_EMAIL | AUTHOR_WHEN | COMMITTER_NAME | COMMITTER_EMAIL
const Query_commit_by_id = "SELECT * FROM commits WHERE hash='%s'"
//const Query_commit_by_id = "SELECT * FROM commits WHERE id = '%s'"


//SELECT CONTENTS FROM files WHERE commit_id=‘<older commit>’ AND PATH = ‘FILENAMEPATH