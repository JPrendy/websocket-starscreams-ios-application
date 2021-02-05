module.exports = ({context}) => {
         // Get the existing comments.
    const {data: comments} = await github.issues.listComments({
      owner: context.repo.owner,
      repo: context.repo.repo,
      issue_number: context.payload.number,
    })
    // Find any comment already made by the bot.
    const botComment = comments.find(comment => comment.user.id)
    console.log(botComment)
    
    const commentBody = "test"
    if (botComment) {
      return await github.issues.updateComment({
        owner: context.repo.owner,
        repo: context.repo.repo,
        comment_id: botComment.id,
        body: commentBody
      })
    } else {
      return await github.issues.createComment({
        owner: context.repo.owner,
        repo: context.repo.repo,
        issue_number: context.payload.number,
        body: commentBody
      })
    }
}

  // module.exports = ( ...args ) => {
  //   console.log( args );
  // };
  

  
  