# SD-Hacks-Blockchain

# Write a smart contract or system of smart contracts (that take advantage of a non-blockchain distributed storage solution) for posting categories of hackathon projects and solutions.
# Each problem must specify:
# A reward amount in MTX
# A bond amount that must be attached to each submission.
# A window of time under which hackathon category can take submissions
# "Round" functionality where, in the case of a draw, another round of submissions can be opened per category.
# Each submission must provide:
# A bond in MTX to mitigate Cybil attacks.
# The body of work representing the submission.
# References to all other work used in the creation of this submission.
# References to all contributors of the submission.

# Technical Requirements and Recommendations:
# We recommend using Solidity as your EVM language.
# Storage is expensive! Use off-chain distributed storage for submissions and category descriptions
# Keep trust in mind!
# This is a blockchain solution, after all. An escrow system is a good idea to ensure that those who submit problems can't revoke the prize once a problem has been posted.
# All submission should allow for upvotes and downvotes from those contributors referenced by submissions of a project problem category.
